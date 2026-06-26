# Terraform Modules

A shared library of reusable Terraform modules that provision the AWS infrastructure (and SaaS DNS/integrations) underpinning the entire PureSkill.gg CS2 coaching platform.

## What it does

`terraform-modules` is a flat collection of ~36 standalone Terraform child modules. Each module lives in its own directory with the usual `main.tf` / `variables.tf` / `outputs.tf` / `versions.tf`. There is **no root module, no backend, no `tfvars`, and no application or CI/build tooling** in this repo — it is purely a building-block library. Consuming repos reference a subdirectory by relative path (commonly `../scope`, and in a few cases `../../lib/...`, indicating modules vendored/symlinked into other repos' `lib/` directories at use time).

All modules pin `required_version = "~> 1.0"`. Providers used across the library are `hashicorp/aws`, `integrations/github`, `jianyuan/sentry`, and `time`.

The architectural keystone is the **`scope`** module. Given a `meta` object (`owner`, `app`, `env`, `stage`) plus a `name` and `id`, it computes every naming convention used org-wide so that resource names, log-group paths, and IAM/SSM prefixes stay consistent across every PSGG stack. Nearly every other module instantiates `scope` as `module "this"` to derive its names and tags. The sibling **`const`** module exports canonical IAM action lists and a couple of hardcoded constants so downstream stacks build least-privilege policies from shared values.

The modules fall into clear groups:

- **Core AWS primitives** — `bucket` (hardened S3), `queue` and `data_queue` (SQS + paired DLQ; `data_queue` also wires an S3 event trigger), `event_deadletter` (EventBridge rule DLQ).
- **Compute / containers** — `cluster` (ECS on a spot EC2 ASG), `container` (ECS task def + service), `container_definition` (renders the container JSON), `ecr` (image repo), `ecs_sqs_autoscaling` (queue-depth autoscaler), `instance` (raw EC2), `vpc`.
- **Edge / web** — `cdn` (CloudFront over a private S3 bucket), `edge` (CloudFront over an API-gateway origin), `certificate` (ACM + DNS validation), `cognito` (user pool), `appsync_api_key` (auto-rotating key), `eventbus` (EventBridge bus + archive).
- **Config / identity / secrets** — `parameters` (SSM), `parameter_set` (a JSON blob written as one DynamoDB item), `secret`/`secrets` (Secrets Manager read/create), `user`/`developer` (IAM users), `grafana`, `github_repo`.
- **Third-party DNS / integration bundles** — `ses`, `sendgrid`, `flywheel` (also SendGrid — name is misleading), `customerio`, `stripe`, `gsuite`, `github_dommain`, `sentry_project`, `sentry_dsn`.

## Pipeline role

This is **foundational infrastructure-as-code, not a runtime service in the match pipeline.** It produces nothing at runtime and consumes no match data itself.

Every other PSGG repo's Terraform stack consumes these modules to stand up the AWS primitives the pipeline runs on: the S3 buckets that hold demos/csds/replay data, the SQS queues and dead-letter queues referenced throughout the demo/replay/automatch/ppp flows, the ECS clusters and services that run the containerized workers (rushb replay, scv demo, ppp converter, and friends), EventBridge buses, the Cognito pool that backs Steam/FACEIT-linked players, CloudFront CDNs, and the IAM/SSM/Secrets plumbing.

In other words, this repo is the layer that **defines** the queues, buckets, and autoscaling whose failures are triaged at runtime by the `psgg-debug-dlq` and `psgg-debug-jobid` skills. It sits upstream of every service repo and is consumed by them, never the other way around.

> Note: a separate `makenew-tf-module` template repo provides the scaffolding for a single new module. **This** repo is the concrete shared-module *collection* — distinct from those one-off templates, and distinct from any service repo's own `lib/` modules (which may vendor modules from here).

## Modules

Resources are named by the `scope` module from `meta.owner/app/env/stage` plus `name`/`id`. There are **no literal resource names or ARNs in this repo** — everything below is templated.

| Module | Provisions |
| --- | --- |
| `scope` | Naming/tagging engine. Derives `name` (`owner-app-env-name-id`), `name_prefix`, `log_group` (`/owner/app/env/name/id`), `parameter_prefixes`, `iam_path`, `iam_name_prefix`, `iam_group_prefix`, `repository` (`owner/app-name`), `function_prefix` (`app-name-stage-`), and tags. Instantiated as `module "this"` almost everywhere. |
| `const` | Shared IAM action lists (`dynamodb` ro/rw, `bucket` ro/w/rw, `sqs_consumer`, `ssm` rw), plus `s3_arn_prefix = "arn:aws:s3:::"` and `cloudfront_zone_id = "Z2FDTNDATAQYW2"`. |
| `queue` | `aws_sqs_queue.main` + `aws_sqs_queue.deadletter` (`${this.name}-deadletter`) via a templated `redrive_policy.json.tpl` (default `maxReceiveCount = 5`); `prevent_destroy` on both. |
| `data_queue` | Same main + DLQ pair **plus** an `aws_s3_bucket_notification` (`s3:ObjectCreated:*`, prefix/suffix filtered) and an `aws_sqs_queue_policy` allowing S3 `SendMessage`. The S3-object-created → SQS ingestion trigger behind the pipeline's data queues. |
| `event_deadletter` | Standalone EventBridge DLQ `${this.name}-${var.rule_name}-deadletter` + a queue policy scoped to `events.amazonaws.com` for rule ARNs matching `${rule_arn_prefix}/${function_prefix}${rule_name}-rule-*`. |
| `bucket` | Hardened `aws_s3_bucket`: private ACL, AES256 SSE, versioning, CORS, lifecycle (STANDARD_IA transition + noncurrent/object expiration), full public-access block; `prevent_destroy`. |
| `cdn` | `aws_cloudfront_distribution` over a private S3 origin via `aws_cloudfront_origin_access_identity` + restrictive `aws_s3_bucket_policy` + Route53 A-alias. |
| `edge` | `aws_cloudfront_distribution` with a custom (API-gateway) origin, one ACM certificate via `module "certificate"`, and a Route53 alias. |
| `certificate` | `aws_acm_certificate` (DNS validation) + Route53 records + `aws_acm_certificate_validation`. |
| `cluster` | ECS cluster via `terraform-aws-modules/ecs` v4.0.1 on a spot EC2 ASG (`terraform-aws-modules/autoscaling`, `market_type = spot`) with an ECS managed capacity provider (managed scaling + termination protection). |
| `container` | `aws_ecs_task_definition` + `aws_ecs_service` (deployment circuit breaker w/ rollback, binpack-by-memory, capacity-provider strategy) + a task `aws_iam_role` with X-Ray access + an `aws_cloudwatch_log_group`. |
| `container_definition` | Renders the ECS container-def JSON from templates, carving out a fixed **32 CPU / 256 MB** for an optional X-Ray sidecar (`xray_enabled`) and `jsonencode`-ing both plaintext env vars and SSM/Secrets-backed secrets. |
| `ecs_sqs_autoscaling` | Scales an ECS service on the SQS `ApproximateNumberOfMessagesVisible` metric (queue-depth-driven worker autoscaling). |
| `ecr` | `aws_ecr_repository` named `owner/app-name` + `aws_ecr_lifecycle_policy` (365-image count). |
| `cognito` | `aws_cognito_user_pool` (email alias/auto-verify, `DEVELOPER` SES email sending, custom schema attrs `env`/`origin`/`marketing_signup`/`affiliate`/`retro_affiliate`/`referrer`); `prevent_destroy`, `ignore_changes` on `lambda_config`. |
| `appsync_api_key` | `aws_appsync_api_key` for a caller-supplied AppSync API id, rotated by a `time_rotating` resource (no GraphQL API is defined here). |
| `eventbus` | `aws_cloudwatch_event_bus` + `aws_cloudwatch_event_archive` (15-day retention); exposes a `rule_arn_prefix` output. |
| `parameters` | `aws_ssm_parameter` (`for_each`, `overwrite = true`) at `/owner/app/stage/name/key`. |
| `parameter_set` | A single `aws_dynamodb_table_item` written into a **caller-supplied** `table_name` (hash key `/owner/app/stage/name`). Does **not** create the table. |
| `secrets` / `secret` | `secrets` creates `aws_secretsmanager_secret` + `secret_version`; `secret` is read-only (a `data` lookup by templated name). |
| `vpc` / `instance` | `vpc` wraps `terraform-aws-modules/vpc` v3.14.1; `instance` provisions `aws_instance` + IAM role/instance-profile. |
| `user` / `developer` | IAM users with access keys + attached policies; `developer` adds group membership. |
| `grafana` | `grafana_data_source` (CloudWatch) backed by a dedicated IAM user. |
| `sentry_project` / `sentry_dsn` | `sentry_project` creates a Sentry project + key and publishes the DSN to SSM; `sentry_dsn` reads a global DSN back out of SSM (read-only). |
| `github_repo` / `github_dommain` | `github_repository` (+ teams, collaborators, Pages); `github_dommain` adds Route53 TXT records for GitHub domain/Pages verification. |
| `ses` | `aws_ses_domain_identity` + verification + `noreply` email identity + identity policies + Route53 records. |
| `sendgrid` / `flywheel` | SendGrid DKIM/SPF/reverse Route53 records (`sendgrid.net`). **`flywheel` is also SendGrid** — the name is misleading. |
| `customerio` | Mailgun MX (`mxa`/`mxb`) + DKIM Route53 records for inbound, plus a CloudFront distribution fronting the Customer.io link-tracking domain. |
| `stripe` | Stripe DKIM CNAMEs, `stripe-verification=` TXT, and bounce records. |
| `gsuite` | Google Workspace MX / SPF / DKIM / DMARC Route53 records. |

## Logs & observability

This repo runs nothing, so it has **no runtime error surfaces of its own** — no Sentry init, no `LOG_LEVEL`, no Step Functions here. "Finding logs" for this repo means reading `terraform plan` / `terraform apply` output (run from the **consuming** stack, since there is no CI in this repo). The modules do, however, *encode* the observability patterns every consumer inherits:

- **CloudWatch log groups** follow the `scope`-templated pattern `/{owner}/{app}/{env}/{name}/{id}` (e.g. `/pureskillgg/csgo/prod/<name>`). The `container` module's ECS service logs to a **caller-supplied** `log_group_name` with `retention_in_days` configurable per consumer.
- **Dead-letter queues** — both `queue` and `data_queue` provision a paired `-deadletter` SQS queue with a `redrive_policy` (default `maxReceiveCount = 5`); `event_deadletter` provisions a DLQ for EventBridge rule failures. These are exactly the org-wide `<name>-deadletter` / `<name>-0-deadletter` queues triaged via the `psgg-debug-dlq` skill.
- **ECS deploy failures** auto-roll-back — `container` enables `deployment_circuit_breaker` with `rollback = true`.
- **X-Ray** tracing is opt-in per task via `container_definition`'s `xray_enabled` sidecar; a configurable `log_level` is passed into the task config template.
- **Sentry** is *provisioned* (not consumed) here: `sentry_project` creates the project/key and publishes the DSN to SSM, where apps read it via `sentry_dsn`.
- Many SQS / bucket / certificate / Cognito resources set `lifecycle { prevent_destroy = true }` to guard against accidental teardown.

## Documentation

- [The `scope` naming-convention engine](docs/scope-naming.md) — the exact name/prefix/path formats every other module and downstream repo depends on, and why changing them is dangerous.
- [`data_queue` ingestion & DLQ wiring](docs/data-queue-and-dlq.md) — how the S3-event → SQS → DLQ trigger and the `container_definition` X-Ray/secret carve-out actually fit together.

## License

These Terraform modules are licensed under the MIT license.

## Warranty

This software is provided by the copyright holders and contributors "as is" and
any express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed. In no event shall the copyright holder or contributors be liable for
any direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.

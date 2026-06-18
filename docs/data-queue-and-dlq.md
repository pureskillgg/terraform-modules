# `data_queue` ingestion & DLQ wiring (and the `container_definition` carve-out)

These two modules encode the failure/observability semantics that the rest of the platform — and the `psgg-debug-dlq` triage workflow — depends on.

## `queue` vs `data_queue`

`queue` is the plain pattern: an `aws_sqs_queue.main` plus a sibling `aws_sqs_queue.deadletter` named `${module.this.name}-deadletter`. The main queue's `redrive_policy` is rendered from `redrive_policy.json.tpl` and points failed messages at the DLQ after `maxReceiveCount` deliveries (**default 5**). Both queues set `lifecycle { prevent_destroy = true }`.

`data_queue` is the **ingestion** pattern. It is the same main + DLQ pair, plus two extra pieces that turn an S3 bucket into a message source:

1. `aws_s3_bucket_notification` — fires on `s3:ObjectCreated:*`, filtered by a caller-supplied `filter_prefix` / `filter_suffix`, delivering to the main queue. This is the actual **S3-object-created → SQS** trigger behind the pipeline's demo/data ingestion.
2. `aws_sqs_queue_policy` — grants S3 `SendMessage` on the main queue so the notification is allowed to deliver.

So when a worker's data queue backs up and messages spill into `<name>-deadletter`, the chain that produced them is: object lands in S3 → bucket notification → main queue → consumer fails it `maxReceiveCount` times → DLQ. That is the exact lifecycle the DLQ-debug skill reasons about.

## EventBridge DLQ

`event_deadletter` is the EventBridge analogue: a standalone DLQ named `${module.this.name}-${var.rule_name}-deadletter` whose queue policy permits `events.amazonaws.com` to `SendMessage`, scoped to rule ARNs matching `${eventbus.rule_arn_prefix}/${function_prefix}${rule_name}-rule-*`.

## `container_definition` X-Ray carve-out + secret injection

`container_definition` renders the ECS container-def JSON from templates and does one piece of non-obvious arithmetic: when `xray_enabled` is set, it reserves a **fixed 32 CPU units and 256 MB** for an X-Ray sidecar (`xray.json.tpl`, image `amazon/aws-xray-daemon`) by subtracting them from the task's `cpu`/`memory` before templating the app container:

```
xray_cpu    = 32  * factor
xray_memory = 256 * factor
cpu         = var.cpu    - xray_cpu
memory      = var.memory - xray_memory
```

It also `jsonencode`s two distinct config channels into the container def: plaintext `environment` variables, and `secrets` resolved from SSM Parameter Store / Secrets Manager. This env + secrets contract is what every worker container relies on for runtime configuration, and `log_level` is passed straight through into the task config template.

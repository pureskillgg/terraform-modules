# The `scope` naming-convention engine

`scope` is the keystone of this library. It takes a `meta` object plus a `name` and `id` and computes **every** naming convention used across PureSkill.gg. Nearly every other module instantiates it as `module "this"` and derives its resource names, log-group path, IAM/SSM prefixes, and tags from these outputs.

Because these strings are baked into the names of real, stateful AWS resources across many stacks, **changing the join/compact ordering here renames (and therefore recreates) infrastructure org-wide.** Treat this module as a stable contract.

## Inputs

```
meta = {
  owner = "pureskillgg"
  app   = "csgo"
  env   = "prod"   # or staging, etc.
  stage = "prod"   # stage may differ from env
}
name = "<module name>"
id   = "<optional disambiguator>"
```

## Computed formats

All values are built with `join` over a `compact`-ed list, so an empty `id` is simply dropped (no trailing separator).

| Output | Formula | Example |
| --- | --- | --- |
| `name` | `owner-app-env-name-id` | `pureskillgg-csgo-prod-<name>` |
| `name_prefix` | `app-stage-name-id` | `csgo-prod-<name>` |
| `log_group` | `/owner/app/env/name/id` | `/pureskillgg/csgo/prod/<name>` |
| `ec2_name` | `id-name-env-app-owner` | `<name>-prod-csgo-pureskillgg` |
| `repository` (ECR) | `owner/app-name` | `pureskillgg/csgo-<name>` |
| `iam_path` | `/owner/app/env/` | `/pureskillgg/csgo/prod/` |
| `iam_name_prefix` | `app-stage-name` | `csgo-prod-<name>` |
| `iam_group_prefix` | `owner-app-env-` | `pureskillgg-csgo-prod-` |
| `function_prefix` | `app-name-stage-` | `csgo-<name>-prod-` |
| `parameter_prefixes` | `[owner, app, stage, name]` | joined as `/owner/app/stage/name` for SSM/Secrets/DynamoDB |

`tags` is just `{ Name = var.name }`.

## Why it matters downstream

- **SSM / Secrets / DynamoDB** keys are `/owner/app/stage/name/key` — built from `parameter_prefixes`. The `parameters`, `secrets`, `secret`, and `parameter_set` modules all key off this.
- **CloudWatch log groups** use `log_group`. If you are hunting logs for a service, this is the path pattern.
- **`function_prefix`** drives the EventBridge rule ARN match in `event_deadletter` (`${function_prefix}${rule_name}-rule-*`).
- **`repository`** is the ECR image name (`owner/app-name`) used by `ecr`, and matched by the `container`/`cluster` worker images.

If you need a new naming format, **add** an output rather than altering an existing one.

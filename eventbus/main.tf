module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

locals {
  arn_parts = split("/", aws_cloudwatch_event_bus.main.arn)
  arn_account_parts = split(":", element(local.arn_parts, 0))
  arn_prefix_part = join(":", slice(local.arn_account_parts, 0, 5))
  arn_name_part = element(local.arn_parts, 1)
  rule_arn_prefix = "${local.arn_prefix_part}:rule/${local.arn_name_part}"
}

resource "aws_cloudwatch_event_bus" "main" {
  name = module.this.name
}

resource "aws_cloudwatch_event_archive" "main" {
  name = module.this.name
  event_source_arn = aws_cloudwatch_event_bus.main.arn
  retention_days = 15
}

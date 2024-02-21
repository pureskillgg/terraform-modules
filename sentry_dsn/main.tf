module "this" {
  source = "../scope"
  name = var.name
  id = 0
  meta = var.meta
  tags = var.tags
}

locals {
  prefix = join("/", [
    var.meta.owner,
    "global",
    "sentry"
  ])
}

data "aws_ssm_parameter" "main" {
  name = "/${local.prefix}/${var.meta.app}-${var.name}/dsn"
}

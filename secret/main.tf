module "this" {
  source = "../scope"
  name = var.name
  id = 0
  meta = var.meta
  tags = var.tags
}

locals {
  prefix = join("/", module.this.parameter_prefixes)
}

data "aws_secretsmanager_secret" "main" {
  name = "/${local.prefix}/${var.key}"
}

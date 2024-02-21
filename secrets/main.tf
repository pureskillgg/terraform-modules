module "this" {
  source = "../scope"
  name = var.name
  id = 0
  meta = var.meta
  tags = var.tags
}

locals {
  prefix = join("/", module.this.parameter_prefixes)
  names = formatlist("/${local.prefix}/%s", keys(var.secrets))
}

resource "aws_secretsmanager_secret" "main" {
  for_each = var.secrets
  name = "/${local.prefix}/${each.key}"
  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  for_each = var.secrets
  secret_id = aws_secretsmanager_secret.main[each.key].id
  secret_string = each.value
}

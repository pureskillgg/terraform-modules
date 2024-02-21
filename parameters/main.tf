module "this" {
  source = "../scope"
  name = var.name
  id = 0
  meta = var.meta
  tags = var.tags
}

locals {
  prefix = join("/", module.this.parameter_prefixes)
  names = formatlist("/${local.prefix}/%s", keys(var.parameters))
}

resource "aws_ssm_parameter" "main" {
  for_each = var.parameters
  name = "/${local.prefix}/${each.key}"
  value = each.value
  type = var.type
  tags = module.this.tags
  overwrite = true
}

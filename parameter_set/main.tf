module "this" {
  source = "../scope"
  name = var.name
  id = 0
  meta = var.meta
  tags = var.tags
}

locals {
  prefix = join("/", module.this.parameter_prefixes)
  name = "/${local.prefix}"
}

locals {
  params = { for k, v in var.parameters : k => { "S" = v } }
  item = merge(
    { (var.hash_key) = { "S" = local.name } },
    local.params
  )
}

resource "aws_dynamodb_table_item" "main" {
  table_name = var.table_name
  hash_key = var.hash_key
  item = jsonencode(local.item)
}

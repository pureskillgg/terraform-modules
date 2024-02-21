module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

module "user" {
  source = "../user"
  name = var.name
  meta = var.meta
  tags = var.tags
  policy_documents = [
    data.aws_iam_policy_document.main.json
  ]
}

resource "grafana_data_source" "main" {
  type = "cloudwatch"
  name = module.this.name

  json_data {
    default_region = var.region
    auth_type = "keys"
  }

  secure_json_data {
    access_key = module.user.access_key_id
    secret_key = module.user.secret_access_key
  }
}

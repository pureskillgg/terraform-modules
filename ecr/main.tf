module "this" {
  source = "../scope"
  name = var.name
  id = ""
  meta = var.meta
  tags = var.tags
}

locals {
  lifecycle_policy = templatefile("${path.module}/lifecycle_policy.json.tpl", {
    count = 365
  })
}

resource "aws_ecr_repository" "main" {
  name = module.this.repository
  tags = module.this.tags
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy = local.lifecycle_policy
}

module "this" {
  source = "../scope"
  id = ""
  name = "developer"
  meta = var.meta
  tags = var.tags
}

locals {
  name = join(".", [var.first_name, var.last_name])
}

locals {
  policy_count = length(var.policy_documents)
}

resource "aws_iam_user" "main" {
  name = local.name
  path = module.this.iam_path
  tags = module.this.tags
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}

resource "aws_iam_policy" "main" {
  count = local.policy_count
  name_prefix = module.this.iam_name_prefix
  policy = var.policy_documents[count.index]
}

resource "aws_iam_policy_attachment" "main" {
  count = local.policy_count
  name = "${module.this.name}-${count.index}"
  users = [aws_iam_user.main.name]
  policy_arn = aws_iam_policy.main[count.index].arn
}

resource "aws_iam_user_group_membership" "main" {
  user = aws_iam_user.main.name
  groups = var.groups
}

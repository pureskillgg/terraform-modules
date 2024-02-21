data "aws_iam_policy" "execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "ssm_ro" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

locals {
  parameter_prefix = join("/", slice(
    module.this.parameter_prefixes,
    0,
    length(module.this.parameter_prefixes) - 1
  ))
}

data "aws_iam_policy_document" "secrets_ro" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [join(":", [
      "arn:aws:secretsmanager",
      var.region,
      var.account_id,
      "secret",
      "/${local.parameter_prefix}/*"
    ])]
  }
}

data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "execution" {
  name_prefix = module.this.name_prefix
  path = module.this.iam_path
  assume_role_policy = data.aws_iam_policy_document.execution_assume_role.json
  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "execution" {
  role = aws_iam_role.execution.name
  policy_arn = data.aws_iam_policy.execution.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "execution_ssm" {
  role = aws_iam_role.execution.name
  policy_arn = data.aws_iam_policy.ssm_ro.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "secrets_ro" {
  policy = data.aws_iam_policy_document.secrets_ro.json
  path = module.this.iam_path
  name_prefix = module.this.iam_name_prefix
}

resource "aws_iam_role_policy_attachment" "execution_secrets" {
  role = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.secrets_ro.arn

  lifecycle {
    create_before_destroy = true
  }
}

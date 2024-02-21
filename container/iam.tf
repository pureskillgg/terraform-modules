resource "aws_iam_role" "main" {
  name_prefix = module.this.name_prefix
  path = module.this.iam_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "main" {
  policy = var.policy
  path = module.this.iam_path
  name_prefix = module.this.name_prefix

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "assume_role" {
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

data "aws_iam_policy" "xray_daemon" {
  arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "xray" {
  role = aws_iam_role.main.name
  policy_arn = data.aws_iam_policy.xray_daemon.arn

  lifecycle {
    create_before_destroy = true
  }
}

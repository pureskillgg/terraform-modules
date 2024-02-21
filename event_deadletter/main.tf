module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

resource "aws_sqs_queue" "main" {
  name = "${module.this.name}-${var.rule_name}-deadletter"
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  tags = module.this.tags

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }

    resources = [
      aws_sqs_queue.main.arn
    ]

    condition {
      test = "StringLike"
      variable = "aws:SourceArn"
      values = [
        "${var.eventbus.rule_arn_prefix}/${module.this.function_prefix}${var.rule_name}-rule-*"
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id
  policy = data.aws_iam_policy_document.main.json
}

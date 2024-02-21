data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.main.arn
    ]

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        local.bucket_arn
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id
  policy = data.aws_iam_policy_document.main.json
}

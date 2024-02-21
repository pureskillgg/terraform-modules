data "aws_s3_bucket" "bucket" {
  bucket = var.bucket
}

locals {
  bucket_arn = data.aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "main" {
  bucket = var.bucket

  queue {
    queue_arn = aws_sqs_queue.main.arn
    filter_prefix = var.filter_prefix
    filter_suffix = var.filter_suffix
    events = [
      "s3:ObjectCreated:*"
    ]
  }
}

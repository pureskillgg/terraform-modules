module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

locals {
  redrive_policy = templatefile("${path.module}/redrive_policy.json.tpl", {
    count = var.max_receive_count
    arn = aws_sqs_queue.deadletter.arn
  })
}

resource "aws_sqs_queue" "main" {
  name = module.this.name
  fifo_queue = var.fifo_queue
  message_retention_seconds = var.message_retention_seconds
  redrive_policy = local.redrive_policy
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  delay_seconds = var.delay_seconds
  tags = module.this.tags
  depends_on = [aws_sqs_queue.deadletter]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_sqs_queue" "deadletter" {
  name = "${module.this.name}-deadletter"
  message_retention_seconds = var.deadletter_message_retention_seconds
  tags = module.this.tags

  lifecycle {
    prevent_destroy = true
  }
}

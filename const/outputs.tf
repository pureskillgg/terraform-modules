output "dynamodb_actions_ro" {
  value = local.dynamodb_actions_ro
}

output "dynamodb_actions_rw" {
  value = local.dynamodb_actions_rw
}

output "bucket_actions_ro" {
  value = local.bucket_actions_ro
}

output "bucket_actions_rw" {
  value = local.bucket_actions_rw
}

output "cloudfront_zone_id" {
  value = "Z2FDTNDATAQYW2"
}

output "sqs_consumer_actions" {
  value = local.sqs_consumer_actions
}

output "s3_arn_prefix" {
  value = local.s3_arn_prefix
}

output "ssm_actions_rw" {
  value = local.ssm_actions_rw
}

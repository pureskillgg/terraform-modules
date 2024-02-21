output "arn" {
  value = aws_s3_bucket.main.arn
}

output "id" {
  value = aws_s3_bucket.main.id
}

output "endpoint" {
  value = join(".", [
    "https://${aws_s3_bucket.main.id}",
    "s3",
    aws_s3_bucket.main.region,
    "amazonaws",
    "com"
  ])
}

output "domain_name" {
  value = aws_s3_bucket.main.bucket_domain_name
}

output "regional_domain_name" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

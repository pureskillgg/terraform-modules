output "arn" {
  value = aws_cloudfront_distribution.main.arn
}

output "id" {
  value = aws_cloudfront_distribution.main.id
}

output "fqdn" {
  value = aws_route53_record.main.fqdn
}

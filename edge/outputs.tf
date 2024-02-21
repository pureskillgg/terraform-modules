output "arn" {
  value = aws_cloudfront_distribution.main.arn
}

output "id" {
  value = aws_cloudfront_distribution.main.id
}

output "fqdn" {
  value = aws_route53_record.main.fqdn
}

output "gateway_domain" {
  value = local.gateway_domain_name
}

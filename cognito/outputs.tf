output "id" {
  value = aws_cognito_user_pool.main.id
}

output "arn" {
  value = aws_cognito_user_pool.main.arn
}

output "name" {
  value = aws_cognito_user_pool.main.name
}

output "endpoint" {
  value = aws_cognito_user_pool.main.endpoint
}

output "domain" {
  value = var.domain
}

output "certificate_arn" {
  value = module.certificate.arn
}

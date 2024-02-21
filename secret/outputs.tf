output "arn" {
  value = data.aws_secretsmanager_secret.main.arn
}

output "id" {
  value = data.aws_secretsmanager_secret.main.id
}

output "name" {
  value = data.aws_secretsmanager_secret.main.name
}

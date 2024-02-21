output "arn" {
  value = aws_iam_user.main.arn
}

output "access_key_id" {
  value = aws_iam_access_key.main.id
}

output "secret_access_key" {
  sensitive = true
  value = aws_iam_access_key.main.secret
}

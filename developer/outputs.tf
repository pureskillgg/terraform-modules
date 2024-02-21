output "name" {
  value = aws_iam_user.main.name
}

output "arn" {
  value = aws_iam_user.main.arn
}

output "access_key_id" {
  value = aws_iam_access_key.main.id
}

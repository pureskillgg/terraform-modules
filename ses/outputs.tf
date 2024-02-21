output "domain_identity_arn" {
  value = aws_ses_domain_identity.main.arn
}

output "noreply_email_identity_policy" {
  value = data.aws_iam_policy_document.noreply.json
}

output "noreply_email" {
  value = local.noreply
}

output "noreply_email_identity_arn" {
  value = aws_ses_email_identity.noreply.arn
}

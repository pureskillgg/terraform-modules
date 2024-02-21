output "value" {
  sensitive = true
  value = local.has_appsync ? aws_appsync_api_key.main[0].key : ""
}

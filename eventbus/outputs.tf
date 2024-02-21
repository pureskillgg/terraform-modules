output "arn" {
  value = aws_cloudwatch_event_bus.main.arn
}

output "name" {
  value = aws_cloudwatch_event_bus.main.id
}

output "rule_arn_prefix" {
  value = local.rule_arn_prefix
}

output "id" {
  value = module.ecs.cluster_id
}

output "name" {
  value = local.cluster_name
}

output "name_suffix" {
  value = element(reverse(split("-", module.asg.autoscaling_group_name)), 0)
}

output "execution_role" {
  value = {
    arn = aws_iam_role.execution.arn
  }
}

output "capacity_provider" {
  value = {
    name = module.ecs.autoscaling_capacity_providers["${local.cluster_name}-main"].name
  }
}

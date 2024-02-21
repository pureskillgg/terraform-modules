output "name" {
  value = local.name
}

output "parameter_prefixes" {
  value = local.parameter_prefixes
}

output "name_prefix" {
  value = local.name_prefix
}

output "log_group" {
  value = local.log_group
}

output "iam_path" {
  value = local.iam_path
}

output "iam_name_prefix" {
  value = local.iam_name_prefix
}

output "iam_group_prefix" {
  value = local.iam_group_prefix
}

output "repository" {
  value = local.repository
}

output "function_prefix" {
  value = local.function_prefix
}

output "tags" {
  value = merge(var.tags, local.tags)
}

output "ec2_tags" {
  value = merge(
    var.tags,
    local.tags,
    {
      "Name" = local.ec2_name
      "Group" = var.name
    }
  )
}

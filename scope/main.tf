locals {
  name_prefixes = [
    var.meta.owner,
    var.meta.app,
    var.meta.env,
    var.name
  ]
  name_prefix_prefixes = [
    var.meta.app,
    var.meta.stage,
    var.name
  ]
  parameter_prefixes = [
    var.meta.owner,
    var.meta.app,
    var.meta.stage,
    var.name
  ]
  iam_path_prefixes = [
    var.meta.owner,
    var.meta.app,
    var.meta.env
  ]
  short_id_prefixes = [
    var.meta.app,
    var.meta.stage,
    var.name
  ]
  ec2_name_prefixes = [
    var.name,
    var.meta.env,
    var.meta.app,
    var.meta.owner
  ]
  function_prefixes = [
    var.meta.app,
    var.name,
    var.meta.stage
  ]
  name = join("-", compact(concat(local.name_prefixes, [var.id])))
  name_prefix = join("-", compact(concat(local.name_prefix_prefixes, [var.id])))
  log_group = "/${join("/", compact(concat(local.name_prefixes, [var.id])))}"
  ec2_name = join("-", compact(concat([var.id], local.ec2_name_prefixes)))
  repository = "${var.meta.owner}/${var.meta.app}-${var.name}"
  iam_path = "/${join("/", local.iam_path_prefixes)}/"
  iam_name_prefix = join("-", compact(local.short_id_prefixes))
  iam_group_prefix = "${join("-", local.iam_path_prefixes)}-"
  function_prefix = "${join("-", local.function_prefixes)}-"
}

locals {
  tags = {
    Name = var.name
  }
}

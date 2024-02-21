module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

resource "aws_ecs_task_definition" "main" {
  family = "${module.this.name}-${var.name_suffix}"
  cpu = var.cpu
  memory = var.memory
  task_role_arn = aws_iam_role.main.arn
  execution_role_arn = var.execution_role_arn
  network_mode = var.network_mode
  container_definitions = "[${join(",", var.container_definitions)}]"
  tags = module.this.tags
  depends_on = [aws_cloudwatch_log_group.main]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "main" {
  name = "${module.this.name}-${var.name_suffix}"
  task_definition = aws_ecs_task_definition.main.arn
  desired_count = var.desired_count
  cluster = var.cluster_id
  enable_ecs_managed_tags = true
  propagate_tags = "TASK_DEFINITION"

  network_configuration {
    subnets = var.subnets
    security_groups = var.security_groups
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  ordered_placement_strategy {
    type = "binpack"
    field = "memory"
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight = 1
    base = 0
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      capacity_provider_strategy,
      desired_count
    ]
  }

  tags = module.this.tags
}

resource "aws_cloudwatch_log_group" "main" {
  name = var.log_group_name
  retention_in_days = var.log_retention_in_days
  tags = module.this.tags
}

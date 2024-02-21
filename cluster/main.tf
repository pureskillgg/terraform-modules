module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

data "aws_ami" "main" {
  most_recent = true
  owners = ["amazon"]
  name_regex = "^amzn2-ami-ecs-hvm-2.0.\\d{8}-${var.instance_architecture}-ebs$"
}

locals {
  cluster_name = module.this.name
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws" # external_source
  version = "4.0.1"
  autoscaling_capacity_providers = {
    "${local.cluster_name}-main" = {
      auto_scaling_group_arn = module.asg.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        minimum_scaling_step_size = var.scaling_step_size
        maximum_scaling_step_size = var.scaling_step_size
        status = "ENABLED"
        target_capacity = 100
        instance_warmup_period = 90
      }

      default_capacity_provider_strategy = {
        base = 0
        weight = 1
      }
    }
  }
  cluster_name = local.cluster_name
  tags = module.this.tags
}

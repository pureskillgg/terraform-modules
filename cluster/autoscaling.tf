locals {
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    cluster_name = module.this.name
  })
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws" # external_source
  version = "6.5.0"
  name = module.this.name
  launch_template_name = module.this.name
  create_launch_template = true
  update_default_version = true
  image_id = data.aws_ami.main.id
  instance_type = var.instance_type
  security_groups = var.security_groups
  create_iam_instance_profile = true
  iam_role_use_name_prefix = true
  iam_role_name = module.this.iam_name_prefix
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    CloudWatchLogsFullAccess = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }
  user_data = base64encode(local.user_data)
  vpc_zone_identifier = var.subnets
  health_check_type = "EC2"
  min_size = var.min_size
  max_size = var.max_size
  block_device_mappings = [{
    device_name = data.aws_ami.main.root_device_name
    ebs = {
      encrypted = true
      delete_on_termination = true
      snaptshot_id = data.aws_ami.main.root_snapshot_id
      volume_size = 30
      volume_type = "gp3"
    }
  }]
  desired_capacity = null
  health_check_grace_period = 60
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in = true
  default_cooldown = 90

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  instance_market_options = {
    market_type = "spot"
  }

  termination_policies = [
    "OldestLaunchConfiguration",
    "OldestInstance"
  ]

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = merge({ for k, v in module.this.ec2_tags : k => v if k != "Name" }, {
    AmazonECSManaged = "True"
  })
}

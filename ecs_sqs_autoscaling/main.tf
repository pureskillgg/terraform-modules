module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

module "autoscaling" {
  source = "umotif-public/ecs-service-autoscaling-cloudwatch/aws"
  version = "2.0.0"
  enabled = var.enabled
  name_prefix = module.this.name_prefix

  high_threshold = 5
  low_threshold = 2

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  cluster_name = var.cluster_name
  service_name = var.service_name

  scale_up_step_adjustment = [
    {
      scaling_adjustment = 10
      metric_interval_lower_bound = 1
      metric_interval_upper_bound = ""
    }
  ]

  scale_down_step_adjustment = [
    {
      scaling_adjustment = -8
      metric_interval_upper_bound = 0
      metric_interval_lower_bound = ""
    }
  ]

  metric_query = [
    {
      id = "visible"
      return_data = true
      metric = [
        {
          namespace = "AWS/SQS"
          metric_name = "ApproximateNumberOfMessagesVisible"
          period = 60
          stat = "Maximum"
          dimensions = {
            QueueName = var.queue.name
          }
        }
      ]
    }
  ]

  tags = module.this.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:GetMetricData"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "logs:DescribeLogGroups",
      "logs:GetLogGroupFields",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:GetQueryResults",
      "logs:GetLogEvents"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "tag:GetResources"
    ]
  }

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries",
      "xray:GetTraceGraph",
      "xray:GetGroups",
      "xray:GetTimeSeriesServiceStatistics",
      "xray:GetInsightSummaries",
      "xray:GetInsight",
      "ec2:DescribeRegions"
    ]
  }
}

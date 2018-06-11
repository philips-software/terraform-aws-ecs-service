# --------------------------------------------------------------------------------
# General
# --------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "is_service_running" {
  count = "${var.enable_monitoring ? 1 : 0}"

  alarm_name = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} - Service running"

  comparison_operator = "LessThanThreshold"

  metric_name        = "MemoryUtilization"
  namespace          = "AWS/ECS"
  evaluation_periods = 1
  period             = "60"

  statistic         = "SampleCount"
  threshold         = "1"
  alarm_description = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} service running"

  treat_missing_data = "breaching"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

# --------------------------------------------------------------------------------
# CPU
# --------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_low" {
  count = "${var.enable_monitoring ? 1 : 0}"

  alarm_name          = "LOW ${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} - CPUUtilization >= 80%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  evaluation_periods  = 5
  period              = "60"

  statistic          = "Maximum"
  threshold          = "80"
  alarm_description  = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} cpu utilization to high"
  treat_missing_data = "ignore"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_high" {
  count = "${var.enable_monitoring ? 1 : 0}"

  alarm_name          = "HIGH ${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} - CPUUtilization >= 95%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  evaluation_periods  = 2
  period              = "60"

  statistic          = "Maximum"
  threshold          = "95"
  alarm_description  = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} cpu utilization to high"
  treat_missing_data = "ignore"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

# --------------------------------------------------------------------------------
# Memory
# --------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "service_memory_usage_high" {
  count = "${var.enable_monitoring ? 1 : 0}"

  alarm_name = "HIGH ${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} - MemoryUtilization >= 95%"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  evaluation_periods  = 2
  period              = "60"

  statistic          = "Maximum"
  threshold          = "95"
  alarm_description  = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} memory utilization to high"
  treat_missing_data = "ignore"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

resource "aws_cloudwatch_metric_alarm" "service_memory_usage_low" {
  count = "${var.enable_monitoring ? 1 : 0}"

  alarm_name          = "LOW ${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} - MemoryUtilization >= 80%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"

  statistic          = "Maximum"
  threshold          = "80"
  alarm_description  = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)} memory utilization to high"
  treat_missing_data = "ignore"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.enable_alb ? join("",aws_ecs_service.service_alb.*.name) : join("",aws_ecs_service.service.*.name)}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

# --------------------------------------------------------------------------------
# ALB Target Groups
# --------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "alb_healthy_hostcount_high" {
  count = "${var.enable_monitoring * var.enable_alb}"

  alarm_name          = "HIGH ${aws_ecs_service.service_alb.name} - ALB HealthyHostCount too low < 1"
  comparison_operator = "LessThanThreshold"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  evaluation_periods  = 2
  period              = "60"

  statistic          = "Average"
  threshold          = "1"
  alarm_description  = "${aws_ecs_service.service_alb.name} HealthyHostCount too low"
  treat_missing_data = "breaching"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    LoadBalancer = "${aws_alb.alb.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.target_group.arn_suffix}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_healthy_hostcount_low" {
  count = "${var.enable_monitoring * var.enable_alb}"

  alarm_name          = "LOW ${aws_ecs_service.service_alb.name} - ALB HealthyHostCount too low < desired"
  comparison_operator = "LessThanThreshold"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  evaluation_periods  = 2
  period              = "60"

  statistic          = "Average"
  threshold          = "${aws_ecs_service.service_alb.desired_count}"
  alarm_description  = "${aws_ecs_service.service_alb.name} HealthyHostCount too low"
  treat_missing_data = "ignore"

  actions_enabled           = true
  alarm_actions             = ["${var.monitoring_sns_topic_arn}"]
  ok_actions                = ["${var.monitoring_sns_topic_arn}"]
  insufficient_data_actions = ["${var.monitoring_sns_topic_arn}"]

  dimensions {
    LoadBalancer = "${aws_alb.alb.arn_suffix}"
    TargetGroup  = "${aws_alb_target_group.target_group.arn_suffix}"
  }

  lifecycle {
    ignore_changes = ["threshold", "period", "evaluation_periods"]
  }
}

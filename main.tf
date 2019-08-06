terraform {
  required_version = ">= 0.8.0"
}

/* Template file that renders the container definition */
data "template_file" "docker-template" {
  template = file("${path.module}/templates/task-definition.tpl")

  vars = {
    docker_repository = var.docker_repository
    docker_image_tag  = var.docker_image_tag
    docker_image      = var.docker_image
    container_port    = var.container_port
    service_name      = var.service_name
    container_memory  = var.container_memory
    desired_count     = var.desired_count
    container_cpu     = var.container_cpu == "" ? "" : "\"cpu\": ${var.container_cpu},"
    environment_vars  = var.docker_environment_vars
    logging_config    = var.docker_logging_config == "" ? "" : ",${var.docker_logging_config}"
    mount_points      = var.docker_mount_points == "" ? "" : ",${var.docker_mount_points}"
  }
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.environment}-${var.service_name}"
  dynamic "volume" {
    for_each = var.volumes
    content {
      host_path = volume.value["host_path"]
      name      = volume.value["name"]
    }
  }
  container_definitions = data.template_file.docker-template.rendered
  task_role_arn         = var.task_role_arn
}

locals {
  target_group_arn = var.target_group_arn == "" ? element(concat(aws_alb_target_group.target_group.*.arn, [""]), 0) : var.target_group_arn
}

resource "null_resource" "ecs_services_dependencies" {
  count = var.enable_target_group_connection || var.enable_load_balanced ? 1 : 0

  triggers = {
    listeners = join(",", var.ecs_services_dependencies)
  }
}

resource "aws_ecs_service" "service_alb" {
  count = var.enable_target_group_connection || var.enable_alb || var.enable_load_balanced ? 1 : 0
  depends_on = [
    null_resource.ecs_services_dependencies,
    aws_alb_listener.listener,
    aws_alb_target_group.target_group,
    aws_lb_listener_rule.default,
  ]

  name            = "${var.environment}-${var.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = local.target_group_arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  iam_role = var.ecs_service_role
}

resource "aws_ecs_service" "service" {
  // Only enable if LB is not required
  count = var.enable_target_group_connection || var.enable_alb || var.enable_load_balanced ? 0 : 1

  name            = "${var.environment}-${var.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
}


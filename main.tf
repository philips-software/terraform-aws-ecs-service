terraform {
  required_version = ">= 0.8.0"
}

/* Template file that renders the container definition */
data "template_file" "docker-template" {
  template = "${file("${path.module}/templates/task-definition.tpl")}"

  vars {
    docker_repository = "${var.docker_repository}"
    docker_image_tag  = "${var.docker_image_tag}"
    docker_image      = "${var.docker_image}"
    container_port    = "${var.container_port}"
    service_name      = "${var.service_name}"
    container_memory  = "${var.container_memory}"
    desired_count     = "${var.desired_count}"
    container_cpu     = "${var.container_cpu == "" ? "": "\"cpu\": ${var.container_cpu},"}"
    environment_vars  = "${var.docker_environment_vars}"
    logging_config    = "${var.docker_logging_config == "" ? "" : ",${var.docker_logging_config}"}"
    mount_points      = "${var.docker_mount_points == "" ? "" : ",${var.docker_mount_points}"}"
    extra_properties  = "${length(var.docker_entrypoint) == 0 ? "" : ",\"entryPoint\": ${jsonencode(var.docker_entrypoint)}"}"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.environment}-${var.service_name}"
  volume                = "${var.volumes}"
  container_definitions = "${data.template_file.docker-template.rendered}"
  task_role_arn         = "${var.task_role_arn}"
}

resource "aws_ecs_service" "service_alb" {
  depends_on = ["aws_alb_listener.listener"]

  // Only enable if ALB is required
  count = "${var.enable_alb ? 1 : 0}"

  name            = "${var.environment}-${var.service_name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.desired_count}"

  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }

  iam_role = "${var.ecs_service_role}"
}

resource "aws_ecs_service" "service" {
  // Only enable if ALB is not required
  count = "${var.enable_alb ? 0 : 1}"

  name            = "${var.environment}-${var.service_name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.desired_count}"
}

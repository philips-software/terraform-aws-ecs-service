resource "aws_cloudwatch_log_group" "log_group" {
  name = var.environment

  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-ecs-cluster"
}

data "template_file" "service_role_trust_policy" {
  template = file("policies/service-role-trust-policy.json")
}

resource "aws_iam_role" "ecs_service" {
  name               = "${var.environment}-ecs-role"
  assume_role_policy = data.template_file.service_role_trust_policy.rendered
}

data "template_file" "service_role_policy" {
  template = file("policies/service-role-policy.json")
}

resource "aws_iam_role_policy" "service_role_policy" {
  name   = "${var.environment}-ecs-service-policy"
  role   = aws_iam_role.ecs_service.name
  policy = data.template_file.service_role_policy.rendered
}

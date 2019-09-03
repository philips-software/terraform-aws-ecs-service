locals {
  service_custom_path_path = "docs/"
}

module "service_custom_path" {
  source = "../../"

  environment = var.environment
  project     = var.project

  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "tomcat"
  docker_image_tag = "latest"
  service_name     = "service_custom_path"
  ecs_service_role = module.ecs_cluster.service_role_name

  vpc_id               = module.vpc.vpc_id
  container_port       = "8080"
  enable_load_balanced = true
  listener_arn         = module.lb_service_custom_path.listener_arn

  lb_listener_rule_condition = {
    field  = "path-pattern"
    values = "/${local.service_custom_path_path}*"
  }

  health_check = {
    protocol = "HTTP"
    path     = "/${local.service_custom_path_path}"
    matcher  = "200-399"
    interval = "30"
  }

  // Monitoring settings, disabled
  enable_monitoring = false

  // Enables logging to other targets (default is STDOUT)
  // For CloudWatch logging, make sure the awslogs-group exists
  docker_logging_config = <<EOF
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.environment}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.service_name}"
        }
      }

EOF

}

module "lb_service_custom_path" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs-service-load-balancer.git?ref=terraform012"

  environment = var.environment
  project     = var.project
  name_suffix = "basic-lb"
  type        = "application"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  subnets  = module.vpc.public_subnets

  create_listener = true
  port            = 80

  internal = false
}

data "aws_lb" "lb_service_custom_path" {
  arn = module.lb_service_custom_path.arn
}

output "lb_service_custom_path_dns" {
  value = "http://${data.aws_lb.lb_service_custom_path.dns_name}/${local.service_custom_path_path}"
}


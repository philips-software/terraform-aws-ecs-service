module "service_custom_tg" {
  source = "../../"

  environment = var.environment
  project     = var.project

  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "nginx"
  docker_image_tag = "stable"
  service_name     = "service_custom_tg"
  ecs_service_role = module.ecs_cluster.service_role_name

  vpc_id                         = module.vpc.vpc_id
  container_ssl_enabled          = false
  container_ports                = ["80"]
  alb_container_port             = 80
  enable_target_group_connection = true

  target_group_arn          = aws_alb_target_group.target_group.arn
  ecs_services_dependencies = concat(aws_lb_listener_rule.default.*.arn, [])

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

module "lb_service_custom_tg" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs-service-load-balancer.git?ref=terraform012"

  environment = var.environment
  project     = var.project
  name_suffix = "basic-lb"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  subnets  = module.vpc.public_subnets

  type = "application"
  port = 80

  create_listener = true
  internal        = false
}

data "aws_lb" "lb_service_custom_tg" {
  arn = module.lb_service_custom_tg.arn
}

output "lb_service_custom_tg_dns" {
  value = "http://${data.aws_lb.lb_service_custom_tg.dns_name}/"
}

resource "aws_alb_target_group" "target_group" {
  port     = "80"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
    interval = "30"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "default" {
  listener_arn = module.lb_service_custom_tg.listener_arn

  priority = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}


module "service" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnets
  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "nginx"
  service_name     = "service-default"

  // ALB part, over http without dns entry
  ecs_service_role      = module.ecs_cluster.service_role_name
  enable_alb            = true
  alb_protocol          = "HTTP"
  alb_port              = "80"
  container_ssl_enabled = false
  container_port        = "80"

  // DNS specifc settings for the ALB, disalbed
  enable_dns = false

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
          "awslogs-stream-prefix": "service-default"
        }
      }

EOF

}


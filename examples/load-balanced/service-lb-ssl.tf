locals {
  service_ssl_lb_route53_dns_name        = var.dns_name
  service_ssl_lb_route53_dns_name_prefix = "forest"
}

module "service_ssl_lb_route53" {
  source = "../../"

  environment = var.environment
  project     = var.project

  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "nginx"
  docker_image_tag = "stable"
  service_name     = "service_ssl_lb_route53"
  ecs_service_role = module.ecs_cluster.service_role_name

  vpc_id                = module.vpc.vpc_id
  container_ssl_enabled = false
  container_port        = "80"
  enable_load_balanced  = true
  listener_arn          = module.lb_service_ssl_lb_route53.listener_arn

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

module "lb_service_ssl_lb_route53" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs-service-load-balancer.git?ref=terraform012"

  environment = var.environment
  project     = var.project
  name_suffix = "basic-lb"
  type        = "application"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  subnets  = module.vpc.public_subnets

  create_listener = true
  internal        = false
  port            = 443
  certificate_arn = data.aws_acm_certificate.service_ssl_lb_route53.arn

  dns_name    = "${local.service_ssl_lb_route53_dns_name_prefix}.${local.service_ssl_lb_route53_dns_name}"
  dns_zone_id = data.aws_route53_zone.service_ssl_lb_route53.zone_id
}

output "lb_service_ssl_lb_route53_dns" {
  value = "https://${local.service_ssl_lb_route53_dns_name_prefix}.${local.service_ssl_lb_route53_dns_name}"
}

data "aws_route53_zone" "service_ssl_lb_route53" {
  name = "${local.service_ssl_lb_route53_dns_name}."
}

data "aws_acm_certificate" "service_ssl_lb_route53" {
  domain = "*.${substr(
    data.aws_route53_zone.service_ssl_lb_route53.name,
    0,
    length(data.aws_route53_zone.service_ssl_lb_route53.name) - 1,
  )}"
  statuses = ["ISSUED"]
}


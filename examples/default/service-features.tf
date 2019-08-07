locals {
  volumes = [
    {
      name      = "static_html"
      host_path = "/efs/html"
    },
  ]
}

data "template_file" "volumes_mounts" {
  template = <<EOF
  "mountPoints": [
    {
      "readOnly": null,
      "containerPath": "/usr/share/nginx/html",
      "sourceVolume": "static_html"
    }
  ]
  EOF
}



module "service-features" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnets
  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "nginx"
  service_name     = "service-features"

  // ALB part, over http without dns entry
  ecs_service_role      = module.ecs_cluster.service_role_name
  enable_alb            = true
  alb_protocol          = "HTTP"
  alb_port              = 80
  container_ssl_enabled = false
  container_port        = 80

  // DNS specifc settings for the ALB, disalbed
  enable_dns = false

  health_check = {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
    interval = 30
  }


  docker_mount_points = data.template_file.volumes_mounts.rendered
  volumes             = local.volumes

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
          "awslogs-stream-prefix": "service-features"
        }
      }

EOF

}


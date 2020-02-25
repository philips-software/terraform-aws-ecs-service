resource "aws_security_group" "awsvpc_loadbalanced_sg" {
  name   = "${var.environment}-awsvpc-loadbalanced-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks = [
      "${module.vpc.vpc_cidr}",
    ]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-loadbalanced-awsvpc-sg"
    Environment = "${var.environment}"
  }
}

module "service_loadbalanced" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnets
  ecs_cluster_id   = aws_ecs_cluster.cluster.id
  ecs_cluster_name = aws_ecs_cluster.cluster.name
  docker_image     = "nginx"
  service_name     = "service-loadbalanced"

  // ALB part, over http without dns entry
  enable_alb            = true
  alb_protocol          = "HTTP"
  alb_port              = 80
  container_ssl_enabled = false
  container_port        = 80
  container_cpu         = 256
  container_memory      = 512

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
          "awslogs-stream-prefix": "service-loadbalanced"
        }
      }

EOF

  launch_type                    = "FARGATE"
  awsvpc_service_security_groups = ["${aws_security_group.awsvpc_loadbalanced_sg.id}"]
  awsvpc_service_subnetids       = module.vpc.private_subnets
}


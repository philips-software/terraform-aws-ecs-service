resource "aws_security_group" "awsvpc_sg" {
  name   = "${var.environment}-awsvpc-sg"
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
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-awsvpc-sg"
    Environment = "${var.environment}"
  }
}

module "service" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnets
  ecs_cluster_id   = aws_ecs_cluster.cluster.id
  ecs_cluster_name = aws_ecs_cluster.cluster.name
  docker_image     = "nginx"
  service_name     = "service-default"

  // ALB part, over http without dns entry
  ecs_service_role      = aws_iam_role.ecs_service.name
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
          "awslogs-stream-prefix": "service-default"
        }
      }

EOF

  launch_type                    = "FARGATE"
  awsvpc_service_security_groups = ["${aws_security_group.awsvpc_sg.id}"]
  awsvpc_service_subnetids       = module.vpc.private_subnets
}


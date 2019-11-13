resource "aws_security_group" "service_sg" {
  name   = "${var.environment}-service-sg"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535

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
    Name        = "${var.environment}-service-sg"
    Environment = "${var.environment}"
  }
}

module "service" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnets
  ecs_cluster_id   = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  docker_image     = "nginx"
  service_name     = "service-default"

  // ALB part, over http without dns entry
  ecs_service_role      = module.ecs_cluster.service_role_name
  enable_alb            = true
  alb_protocol          = "HTTP"
  alb_port              = 80
  container_ssl_enabled = false
  container_port        = 80
  container_cpu         = 256
  container_memory      = 512

  // CPU value       Memory value
  // 256 (.25 vCPU)  0.5 GB, 1 GB, 2 GB
  // 512 (.5 vCPU)   1 GB, 2 GB, 3 GB, 4 GB
  // 1024 (1 vCPU)   2 GB, 3 GB, 4 GB, 5 GB, 6 GB, 7 GB, 8 GB
  // 2048 (2 vCPU)   Between 4 GB and 16 GB in 1-GB increments
  // 4096 (4 vCPU)   Between 8 GB and 30 GB in 1-GB increments
  // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html

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

  launch_type = "FARGATE"
  awsvpc_service_security_groups = ["${aws_security_group.service_sg.id}"]
}


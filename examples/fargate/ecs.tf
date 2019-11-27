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

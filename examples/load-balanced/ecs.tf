resource "aws_cloudwatch_log_group" "log_group" {
  name = var.environment

  tags = {
    Name        = var.service_name
    Environment = var.environment
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.ssh_key_file_ecs)
}

data "template_file" "ecs-instance-user-data" {
  template = file("${path.module}/user-data-ecs-cluster-instance.tpl")

  vars = {
    ecs_cluster_name = module.ecs_cluster.name
  }
}

module "ecs_cluster" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs.git?ref=terraform012"

  user_data = data.template_file.ecs-instance-user-data.rendered

  aws_region  = var.aws_region
  environment = var.environment

  key_name = var.key_name

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  min_instance_count     = 1
  max_instance_count     = 2
  desired_instance_count = 2

  instance_type = "t2.micro"

  subnet_ids = join(",", module.vpc.private_subnets)

  project = var.project
}


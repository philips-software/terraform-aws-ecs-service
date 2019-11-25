
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.environment

  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.ssh_key_file_ecs)
}

data "template_file" "ecs_user_data_ecs" {
  template = file("${path.module}/user-data-ecs-cluster-instance.tpl")

  vars = {
    ecs_cluster_name = module.ecs_cluster.name
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.ecs_user_data_ecs.rendered
  }

  part {
    content_type = module.efs.amazon_linux_cloudinit_config_part["content_type"]
    content      = module.efs.amazon_linux_cloudinit_config_part["content"]
  }
}

module "ecs_cluster" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs.git?ref=2.0.0"

  user_data = "${data.template_cloudinit_config.config.rendered}"

  aws_region  = var.aws_region
  environment = var.environment

  key_name = var.key_name

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  min_instance_count     = 0
  max_instance_count     = 0
  desired_instance_count = 0

  instance_type = "t2.micro"

  subnet_ids = join(",", module.vpc.private_subnets)

  project = var.project
}


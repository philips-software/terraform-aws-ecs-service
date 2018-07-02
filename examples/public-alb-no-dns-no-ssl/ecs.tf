module "bastion" {
  source  = "philips-software/bastion/aws"
  version = "1.0.0"

  enable_bastion = "false"

  environment = "${var.environment}"
  project     = "${var.project}"

  aws_region = "${var.aws_region}"
  key_name   = "${aws_key_pair.key.key_name}"
  subnet_id  = "${element(module.vpc.public_subnets, 0)}"
  vpc_id     = "${module.vpc.vpc_id}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.environment}"

  tags {
    Name        = "${var.service_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("${var.ssh_key_file_ecs}")}"
}

data "template_file" "ecs-instance-user-data" {
  template = "${file("${path.module}/user-data-ecs-cluster-instance.tpl")}"

  vars {
    ecs_cluster_name = "${module.ecs_cluster.name}"
  }
}

module "ecs_cluster" {
  source  = "philips-software/ecs/aws"
  version = "1.0.0"

  user_data = "${data.template_file.ecs-instance-user-data.rendered}"

  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"

  key_name = "${var.key_name}"

  vpc_id   = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"

  min_instance_count     = "1"
  max_instance_count     = "1"
  desired_instance_count = "1"

  instance_type = "t2.micro"

  subnet_ids = "${join(",", module.vpc.private_subnets)}"

  project = "${var.project}"
}

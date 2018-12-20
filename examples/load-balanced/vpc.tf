module "vpc" {
  source  = "philips-software/vpc/aws"
  version = "1.2.1"

  environment = "${var.environment}"
  aws_region  = "${var.aws_region}"
}

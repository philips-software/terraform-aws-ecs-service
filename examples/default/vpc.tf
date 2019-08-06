module "vpc" {
  source = "git::https://github.com/philips-software/terraform-aws-vpc.git?ref=terraform012"

  environment = var.environment
  aws_region  = var.aws_region
}


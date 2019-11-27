module "vpc" {
  source = "git::https://github.com/philips-software/terraform-aws-vpc.git?ref=2.0.0"

  environment = var.environment
  aws_region  = var.aws_region
}


module "bastion" {
  source = "git::https://github.com/philips-software/terraform-aws-bastion.git?ref=2.0.0"

  enable_bastion = "false"

  environment = var.environment
  project     = var.project

  aws_region = var.aws_region
  key_name   = aws_key_pair.key.key_name
  subnet_id  = element(module.vpc.public_subnets, 0)
  vpc_id     = module.vpc.vpc_id
}

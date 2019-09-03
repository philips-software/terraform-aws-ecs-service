module "efs" {
  source      = "git::https://github.com/philips-software/terraform-aws-efs.git?ref=terraform012"
  environment = var.environment
  project     = var.project
  subnet_ids  = module.vpc.private_subnets
  vpc_id      = module.vpc.vpc_id
}


module "vpc" {
  source       = "./vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  name_prefix  = var.name_prefix
}

module "iam" {
  source    = "./iam"
  role_name = var.role_name
}

module "lambda" {
  source        = "./lambda"
  function_name = var.function_name
  source_dir    = "${path.module}/../lambda/deployment_gate"
  role_arn      = module.iam.role_arn
}
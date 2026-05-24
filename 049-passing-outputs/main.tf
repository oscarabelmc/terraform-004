terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "subnets" {
  source = "./modules/subnets"

  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
}

module "load_balancer" {
  source = "./modules/load_balancer"

  # TODO: Pass the subnet ID from the subnets module
  # subnet_id = module.subnets.subnet_id
  vpc_id = module.subnets.vpc_id
}

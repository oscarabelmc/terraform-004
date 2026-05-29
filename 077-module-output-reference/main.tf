terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = "pr0d-east-vpc"
  cidr = "10.0.0.0/16"
}

module "ec2_instances" {
  source = "./modules/ec2"

  name           = "pr0d-east-app"
  instance_count = 2
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnets[0]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_ids" {
  value = module.ec2_instances.instance_ids
}

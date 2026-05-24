terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "./modules/network"

  name = "production"
  cidr = "10.5.0.0/16"
}

resource "aws_subnet" "primary_core" {
  vpc_id     = module.network.vpc_id
  cidr_block = "10.5.0.0/23"

  tags = {
    Name = "primary-core-subnet"
  }
}

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
  source = "./modules/config"

  name = "init-demo"
  cidr = "10.0.0.0/16"
}

resource "random_pet" "name" {
  length = 2
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "pet_name" {
  value = random_pet.name.id
}

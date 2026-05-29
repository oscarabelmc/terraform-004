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

module "network" {
  source = "./modules/network"

  name = "production"
  cidr = "10.5.0.0/16"
}

resource "local_file" "config" {
  filename = "${path.module}/output.txt"
  content  = "vpc_id = ${module.network.vpc_id}"
}

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

# Using a module from HCP Terraform's private registry
module "networking" {
  source = "./modules/networking"

  name = "production"
  cidr = "10.0.0.0/16"
}

module "database" {
  source = "./modules/database"

  engine      = "postgres"
  version_str = "15"
  tier        = "medium"
  network_id  = module.networking.network_id
}

output "network_id" {
  value = module.networking.network_id
}

output "database_endpoint" {
  value = module.database.endpoint
}

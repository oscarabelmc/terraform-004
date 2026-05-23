# Upstream workspace: networking
# After apply, this triggers a downstream run in the "app" workspace.

terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  cloud {
    organization = "my-org"
    workspaces {
      name = "networking"
    }
  }
}

resource "random_pet" "vpc" {
  prefix = "vpc"
  length = 2
}

output "vpc_name" {
  value       = random_pet.vpc.id
  description = "Consumed by downstream workspaces via run triggers"
}

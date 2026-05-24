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
    hostname     = "app.terraform.io"
    workspaces {
      name = "cli-workflow-demo"
    }
  }
}

resource "random_pet" "server" {
  prefix = "cli-demo"
  length = 2
}

output "server_name" {
  description = "Random pet name generated in HCP Terraform"
  value       = random_pet.server.id
}

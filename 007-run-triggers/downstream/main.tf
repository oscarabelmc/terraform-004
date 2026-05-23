# Downstream workspace: app
# A run is automatically queued here when the "networking" workspace
# completes a successful apply — via a run trigger.

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
      name = "app"
    }
  }
}

data "terraform_remote_state" "networking" {
  backend = "remote"
  config = {
    organization = "my-org"
    workspaces = {
      name = "networking"
    }
  }
}

resource "random_pet" "app_server" {
  prefix = data.terraform_remote_state.networking.outputs.vpc_name
  length = 1
}

output "app_server_name" {
  value = random_pet.app_server.id
}

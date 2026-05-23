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
      name = "vcs-demo"
    }
  }
}

resource "random_pet" "server" {
  prefix = "web"
  length = 2
}

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
      name = "local-exec-demo"
    }
  }
}

resource "random_pet" "example" {
  prefix = "hcp-local"
  length = 2
}

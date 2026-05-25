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
      name = "app-production"
    }
  }
}

variable "environment" {
  type    = string
  default = "production"
}

resource "random_pet" "app" {
  prefix = "app-${var.environment}"
  length = 2
}

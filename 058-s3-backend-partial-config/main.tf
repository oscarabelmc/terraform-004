terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "s3" {}
}

resource "random_pet" "main" {
  prefix = "partial-backend"
  length = 2
}

terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

resource "random_pet" "name" {
  length = 3
}

resource "random_password" "db" {
  length  = 16
  special = false
}

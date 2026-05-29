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

resource "random_password" "db_master" {
  length  = 24
  special = true
}

resource "random_pet" "main" {
  prefix = "sensitive-output"
  length = 2
}

output "password" {
  value     = random_password.db_master.result
  sensitive = true
}

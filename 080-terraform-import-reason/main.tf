terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

import {
  to = random_pet.production
  id = "manually-created-db-instance"
}

resource "random_pet" "production" {
  prefix = "manually"
  length = 2
}

variable "db_password" {
  type      = string
  sensitive = true
}

output "db_name" {
  value = random_pet.production.id
}

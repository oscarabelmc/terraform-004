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

# Previously named "random_pet.web_server"
# Refactored to a more descriptive name
moved {
  from = random_pet.web_server
  to   = random_pet.application
}

resource "random_pet" "main" {
  prefix = "moved-block"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "vpc = ${random_pet.main.id}"
}

resource "random_pet" "application" {
  prefix = "refactored"
  length = 2
}

output "app_id" {
  value = random_pet.application.id
}

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

resource "random_pet" "server" {
  prefix = var.db_password
  length = 1
}

resource "local_file" "config" {
  filename = "${path.module}/${random_pet.server.id}.cfg"
  content  = "password: ${var.db_password}"
}

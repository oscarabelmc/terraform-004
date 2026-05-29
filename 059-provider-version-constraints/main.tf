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

resource "random_pet" "name" {
  length = 3
}

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = "name = ${random_pet.name.id}"
}

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

resource "random_pet" "main" {
  prefix = "plan-demo"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = "id = ${random_pet.main.id}"
}

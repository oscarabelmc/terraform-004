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
  prefix = "multi-provider"
  length = 2
}

resource "local_file" "config" {
  content  = "Server: ${random_pet.server.id}"
  filename = "${path.module}/server-config.txt"
}

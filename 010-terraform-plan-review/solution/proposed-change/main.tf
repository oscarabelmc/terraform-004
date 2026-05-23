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
  prefix = "web"
  length = 5
}

resource "local_file" "info" {
  filename = "${path.module}/${random_pet.server.id}.txt"
  content  = "Server: ${random_pet.server.id}\nTier: production"
}

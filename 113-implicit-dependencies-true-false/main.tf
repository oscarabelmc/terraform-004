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

# Implicit dependency: local_file references random_pet
resource "random_pet" "server" {
  length = 2
}

resource "local_file" "config" {
  content  = "Server: ${random_pet.server.id}"
  filename = "${path.module}/config.txt"
}

# No depends_on needed — Terraform detects the reference automatically

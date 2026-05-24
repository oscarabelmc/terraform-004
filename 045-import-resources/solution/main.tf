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
  prefix = "existing"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/server-config-existing-pet.txt"
  content  = "Server: ${random_pet.server.id}"
}

import {
  to = random_pet.server
  id = "existing-abc123"
}

import {
  to = local_file.config
  id = "${path.module}/server-config-existing-pet.txt"
}

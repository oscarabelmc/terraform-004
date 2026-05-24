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

import {
  to = random_pet.server
  id = "PLACEHOLDER_ID"
}

import {
  to = local_file.config
  id = "PLACEHOLDER_PATH"
}

resource "random_pet" "server" {
  prefix = "existing"
  length = 2
}

resource "local_file" "config" {
  filename = "PLACEHOLDER_FILENAME"
  content  = "Server: ${random_pet.server.id}"
}

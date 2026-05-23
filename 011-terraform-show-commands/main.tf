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
  length = 2
}

resource "random_pet" "client" {
  prefix = "app"
  length = 2
}

resource "local_file" "server_info" {
  filename = "${path.module}/server-${random_pet.server.id}.txt"
  content  = "Server: ${random_pet.server.id}"
}

resource "local_file" "client_info" {
  filename = "${path.module}/client-${random_pet.client.id}.txt"
  content  = "Client: ${random_pet.client.id}"
}

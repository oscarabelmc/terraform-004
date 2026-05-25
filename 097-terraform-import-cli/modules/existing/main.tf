terraform {
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
  filename = "${path.module}/server-config-${random_pet.server.id}.txt"
  content  = "Server: ${random_pet.server.id}"
}

output "server_id" {
  value = random_pet.server.id
}

output "file_path" {
  value = local_file.config.filename
}

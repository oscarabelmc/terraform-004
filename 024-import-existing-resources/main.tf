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

# TODO: Write resource blocks matching the existing infrastructure
resource "random_pet" "server" {
  prefix    = "existing"
  length    = 2
}

resource "local_file" "config" {
  content  = "Server: ${random_pet.server.id}"
  filename = "existing-glad-pegasus"
}
# TODO: Add import blocks to bring existing resources into state

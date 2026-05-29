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
  prefix = "main"
  length = 2
}

resource "local_file" "public" {
  filename = "${path.module}/public.txt"
  content  = "subnet: public\nvpc: ${random_pet.main.id}"
}

resource "local_file" "private" {
  filename = "${path.module}/private.txt"
  content  = "subnet: private\nvpc: ${random_pet.main.id}"
}

output "vpc_id" {
  value = random_pet.main.id
}

output "public_file" {
  value = local_file.public.filename
}

output "private_file" {
  value = local_file.private.filename
}

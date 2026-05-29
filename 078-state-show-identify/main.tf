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

variable "instance_count" {
  type    = number
  default = 2
}

resource "random_pet" "main" {
  prefix = "state-show"
  length = 2
}

resource "random_pet" "web" {
  count  = var.instance_count
  prefix = "managed-vm"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "vpc = ${random_pet.main.id}"
}

output "vpc_id" {
  value = random_pet.main.id
}

output "web_ids" {
  value = random_pet.web[*].id
}

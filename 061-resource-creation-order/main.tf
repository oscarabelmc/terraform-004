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

variable "existing_disk" {
  type = string
}

resource "random_pet" "web" {
  prefix = "order"
  length = 2
}

resource "local_file" "data" {
  filename = "${path.module}/attachment.txt"
  content  = "instance = ${random_pet.web.id}\ndisk = ${var.existing_disk}"
}

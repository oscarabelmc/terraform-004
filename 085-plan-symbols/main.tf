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

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "random_pet" "main" {
  prefix = "plan-symbols"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "id = ${random_pet.main.id}"
}

output "id" {
  value = random_pet.main.id
}

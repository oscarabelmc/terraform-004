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

  cloud {
    organization = "my-org"
    hostname     = "app.terraform.io"

    workspaces {
      name = "security-scanner-demo"
    }
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

resource "random_pet" "main" {
  prefix = "run-task-demo-${var.environment}"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "name = ${random_pet.main.id}"
}

output "name" {
  value = random_pet.main.id
}

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
      name = "variable-scope-demo"
    }
  }
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "common_tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "platform-team"
  }
}

resource "random_pet" "main" {
  prefix = "scope-demo-${var.environment}"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "name = ${random_pet.main.id}"
}

output "name" {
  value = random_pet.main.id
}

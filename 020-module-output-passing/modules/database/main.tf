terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "name" {
  description = "Database name"
  type        = string
}

resource "random_pet" "db" {
  prefix = var.name
  length = 2
}

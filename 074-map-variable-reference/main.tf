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

variable "metadata" {
  type = map(string)
  default = {
    owner     = "platform"
    build-tag = "v5.0.2"
    service   = "billing"
  }
}

locals {
  build_tag = var.metadata["build-tag"]
}

resource "random_pet" "main" {
  prefix = "app-${local.build_tag}"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "tag = ${local.build_tag}"
}

output "build_tag" {
  value = local.build_tag
}

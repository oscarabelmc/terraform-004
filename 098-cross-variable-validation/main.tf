terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "cluster" {
  count   = var.create_cluster ? 1 : 0
  prefix  = "cluster"
  length  = 3
}

locals {
  endpoint = var.create_cluster ? random_pet.cluster[0].id : var.cluster_endpoint
}

output "resolved_endpoint" {
  value = local.endpoint
}

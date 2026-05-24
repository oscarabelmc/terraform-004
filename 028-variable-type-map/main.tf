terraform {
  required_version = ">= 1.5"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "region" {
  description = "Target region for deployment"
  type        = string
}

variable "image" {
  description = "Map of region → image ID"
  type        = map(string)
}

locals {
  resolved_image = var.image[var.region]
}

resource "null_resource" "deploy" {
  triggers = {
    region = var.region
    image  = local.resolved_image
  }

  provisioner "local-exec" {
    command = "echo Deploying ${local.resolved_image} in ${var.region}"
  }
}

output "deployment_info" {
  value = "Region: ${var.region}, Image: ${local.resolved_image}"
}

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

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Owner       = "platform-team"
    Project     = "billing"
  }
}

locals {
  resource_tags = {
    Name    = "billing-api"
    Service = "api-gateway"
    Backup  = "daily"
  }

  merged_tags = merge(var.common_tags, local.resource_tags)
}

resource "random_pet" "main" {
  prefix = "billing"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/tags.txt"
  content  = join("\n", [for k, v in local.merged_tags : "${k} = ${v}"])
}

output "merged_tags" {
  value = local.merged_tags
}

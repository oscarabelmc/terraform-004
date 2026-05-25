terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "env" {
  type        = string
  default     = "production"
  description = "Environment name for resource naming"
}

module "web" {
  source = "./modules/web"
  # TODO: pass env variable from root to child
  # env = var.env
}

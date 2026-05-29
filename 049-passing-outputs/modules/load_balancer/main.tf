terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "subnet_id" {
  description = "The subnet ID to attach the load balancer to"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

resource "random_pet" "main" {
  prefix = "outputs-lb"
  length = 2
  keepers = {
    subnet_id = var.subnet_id
    vpc_id    = var.vpc_id
  }
}

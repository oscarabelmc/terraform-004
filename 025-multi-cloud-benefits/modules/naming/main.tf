variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "env" {
  description = "Environment identifier"
  type        = string
}

variable "location" {
  description = "Cloud region/location"
  type        = string
}

resource "random_pet" "this" {
  prefix = var.prefix
  length = 2
}

locals {
  name = "${var.prefix}-${var.env}-${random_pet.this.id}"
}

output "name" {
  value = local.name
}

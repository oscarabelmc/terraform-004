terraform {
  required_version = ">= 1.5"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

output "config" {
  value = {
    region           = var.region
    instance_count   = var.instance_count
    monitoring       = var.enable_monitoring
    tags             = var.tags
  }
}

# Example module — in practice this would be in its own repo and published
# to the HCP Terraform private registry via VCS connection

variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

output "vpc_id" {
  value = "vpc-12345"
}

output "public_subnets" {
  value = ["subnet-abc", "subnet-def"]
}

output "private_subnets" {
  value = ["subnet-ghi", "subnet-jkl"]
}

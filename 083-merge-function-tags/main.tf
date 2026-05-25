terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
    Name        = "billing-api"
    Service     = "api-gateway"
    Backup      = "daily"
  }

  merged_tags = merge(var.common_tags, local.resource_tags)
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(var.common_tags, { Name = "billing-vpc" })
}

resource "aws_instance" "api" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = merge(var.common_tags, local.resource_tags)
}

resource "aws_s3_bucket" "logs" {
  bucket = "billing-logs"

  tags = merge(var.common_tags, {
    Name = "billing-logs"
    Retention = "90days"
  })
}

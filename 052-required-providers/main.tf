terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "random" {
  # No configuration needed for random provider
}

resource "random_pet" "bucket" {
  prefix = "demo"
  length = 2
}

resource "aws_s3_bucket" "data" {
  bucket = random_pet.bucket.id
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

output "bucket_name" {
  value = aws_s3_bucket.data.bucket
}

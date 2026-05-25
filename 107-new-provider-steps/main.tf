terraform {
  required_version = ">= 1.5"
  # Step 1: Add required_providers block
  # required_providers {
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "~> 5.0"
  #   }
  # }
}

# Step 1: Add provider configuration block
# provider "aws" {
#   region = "us-east-1"
# }

# Step 2: Run terraform init to download the provider plugin

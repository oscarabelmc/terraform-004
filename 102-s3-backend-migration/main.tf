terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  # Step 1: Start with no backend (local default)
  # Step 2: Add the following block to migrate to S3:
  #
  # backend "s3" {
  #   bucket = "my-company-terraform-state"
  #   key    = "projects/my-project/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

resource "random_pet" "backend_demo" {
  length = 3
  prefix = "s3-migration"
}

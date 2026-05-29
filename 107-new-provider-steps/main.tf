terraform {
  required_version = ">= 1.5"
  # Step 1: Add required_providers block
  # required_providers {
  #   random = {
  #     source  = "hashicorp/random"
  #     version = "~> 3.6"
  #   }
  # }
}

# Step 1: Add provider configuration block
# provider "random" {
# }

# Step 2: Run terraform init to download the provider plugin

terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Simulating a resource that requires recreation on attribute change
resource "random_pet" "database" {
  length = 2
  prefix = "prod-db"

  # Changing the separator forces recreation (simulates SKU change)
  separator = "-"

  lifecycle {
    # TODO: Add create_before_destroy = true to avoid downtime
  }
}

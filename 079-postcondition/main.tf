terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "web" {
  prefix = "postcondition"
  length = 2

  lifecycle {
    postcondition {
      condition     = self.id != ""
      error_message = "Resource did not receive a valid ID."
    }
  }
}

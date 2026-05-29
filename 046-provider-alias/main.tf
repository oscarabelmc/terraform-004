terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Default provider configuration (no alias)
provider "random" {
}

# Second provider configuration — causes duplicate error without alias
provider "random" {
}

resource "random_pet" "web_us" {
  prefix = "web-us"
  length = 2
}

resource "random_pet" "web_mumbai" {
  prefix = "web-mumbai"
  length = 2
}

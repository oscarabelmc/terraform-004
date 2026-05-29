terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

resource "time_sleep" "wait" {
  create_duration = "1s"
}

resource "random_pet" "data" {
  prefix = "example"
  length = 2
  keepers = {
    id = time_sleep.wait.id
  }
}

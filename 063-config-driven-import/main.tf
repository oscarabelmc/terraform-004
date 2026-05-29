terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

import {
  to = random_pet.data_lake
  id = "imported-data-lake"
}

resource "random_pet" "data_lake" {
  prefix = "imported"
  length = 2
}

resource "local_file" "info" {
  filename = "${path.module}/bucket-info.txt"
  content  = "bucket = ${random_pet.data_lake.id}"
}

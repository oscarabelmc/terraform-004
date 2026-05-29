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

resource "random_pet" "bucket" {
  prefix = "demo"
  length = 2
}

resource "local_file" "data" {
  filename = "${path.module}/data.txt"
  content  = "bucket = ${random_pet.bucket.id}"
}

output "bucket_name" {
  value = random_pet.bucket.id
}

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

resource "random_pet" "app_core" {
  prefix = "app"
  length = 2
}

resource "random_pet" "data_volume" {
  prefix = "data"
  length = 2
}

resource "local_file" "attachment" {
  filename = "${path.module}/attachment.txt"
  content  = <<-EOT
    instance_id = ${random_pet.app_core.id}
    volume_id   = ${random_pet.data_volume.id}
  EOT
}

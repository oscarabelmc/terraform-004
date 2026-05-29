terraform {
  required_version = ">= 1.5"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
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

data "http" "prod" {
  url = "https://api.github.com/repos/hashicorp/terraform"
}

resource "random_pet" "app" {
  prefix = "app"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/ref-data.txt"
  content  = <<-EOT
    repo_name = data.http.prod.response_body
    pet_id    = ${random_pet.app.id}
  EOT
}

output "reference_data" {
  value = data.http.prod.response_body
}

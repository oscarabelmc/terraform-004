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
  }
}

data "http" "terraform_releases" {
  url = "https://api.github.com/repos/hashicorp/terraform/releases/latest"
}

resource "random_pet" "web" {
  prefix = "web"
  length = 2
}

output "latest_release" {
  value = data.http.terraform_releases.response_body
}

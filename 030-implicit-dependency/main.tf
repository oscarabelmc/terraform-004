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

resource "random_pet" "company_data" {
  prefix = "company"
  length = 2
}

resource "random_pet" "web_server" {
  prefix     = "web"
  length     = 2
  depends_on = [random_pet.company_data]
}

resource "local_file" "public_ip" {
  filename = "${path.module}/public-ip.txt"
  content  = "web_server_id = ${random_pet.web_server.id}"
}

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

# Database resources removed — no longer managed by Terraform

# Other infrastructure (keep running)
resource "random_pet" "server" {
  prefix = "web"
  length = 2
}

resource "random_pet" "cache" {
  prefix = "redis"
  length = 2
}

resource "random_pet" "queue" {
  prefix = "sqs"
  length = 2
}

resource "local_file" "inventory" {
  filename = "${path.module}/inventory.txt"
  content  = <<-EOT
    server:   ${random_pet.server.id}
    cache:    ${random_pet.cache.id}
    queue:    ${random_pet.queue.id}
  EOT
}

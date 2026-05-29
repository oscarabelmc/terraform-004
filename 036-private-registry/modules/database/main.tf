variable "engine" {
  type = string
}

variable "version_str" {
  type = string
}

variable "tier" {
  type = string
}

variable "network_id" {
  type = string
}

resource "random_pet" "db" {
  prefix = var.engine
  length = 2
}

output "endpoint" {
  value = "${random_pet.db.id}.${var.network_id}.example.com"
}

variable "client_id" {
  type = string
}

variable "hvn_id" {
  type = string
}

variable "route_table_id" {
  type = string
}

resource "random_pet" "main" {
  prefix = "config"
  length = 2
}

output "transit_gateway_attachment_id" {
  value = random_pet.main.id
}

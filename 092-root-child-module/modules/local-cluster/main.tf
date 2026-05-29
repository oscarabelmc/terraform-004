variable "servers" {
  type        = number
  description = "Number of servers to create"
}

resource "random_pet" "server" {
  count  = var.servers
  prefix = "server"
  length = 1
}

variable "name" {
  description = "Name label for the network"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the network"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

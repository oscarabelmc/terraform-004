variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.0.0/24", "10.0.2.0/24"]
}

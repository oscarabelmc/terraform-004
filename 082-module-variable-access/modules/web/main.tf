variable "instance_type" {
  description = "Instance type"
  type        = string
}

resource "random_pet" "web" {
  prefix = "module-web"
  length = 2
}

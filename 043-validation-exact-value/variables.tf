variable "instance_count" {
  description = "Number of web server instances"
  type        = number

  validation {
    condition     = var.instance_count == 2
    error_message = "This module requires exactly 2 instances."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Instance type must be one of: t3.micro, t3.small, t3.medium."
  }
}

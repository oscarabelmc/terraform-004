variable "content" {
  description = "File content"
  type        = string
  default     = "Hello, Terraform!"
}

variable "filename" {
  description = "Output filename"
  type        = string
  default     = "${path.module}/output.txt"
}

variable "file_permission" {
  description = "File permission"
  type        = string
  default     = "0644"
}

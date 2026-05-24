terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

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

resource "local_file" "example" {
  content     = var.content
  filename    = var.filename
  file_permission = var.file_permission
}

output "file_path" {
  value = local_file.example.filename
}

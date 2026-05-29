variable "names" {
  description = "List of user names"
  type        = list(string)
  default     = {}
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 3
}

variable "enabled" {
  description = "Decide whether to enable the feature"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of resource tags"
  type        = map(string)
  default = {
    Environment = "prod"
    Owner       = "platform-team"
  }
}

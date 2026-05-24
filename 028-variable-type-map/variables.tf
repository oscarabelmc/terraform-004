variable "region" {
  description = "Target region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "image" {
  description = "Map of region names to AMI IDs"
  type        = map(string)
  default = {
    us-east-1 = "ami-0c55b159cbfafe1f0"
    us-west-2 = "ami-0c55b159cbfafe1f1"
    eu-west-1 = "ami-0c55b159cbfafe1f2"
  }
}

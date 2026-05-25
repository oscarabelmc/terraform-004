variable "create_cluster" {
  type    = bool
  default = true
}

variable "cluster_endpoint" {
  type    = string
  default = ""

  validation {
    condition     = var.create_cluster == false ? length(var.cluster_endpoint) > 0 : true
    error_message = "You must specify a value for cluster_endpoint if create_cluster is false."
  }
}

terraform {
  required_version = ">= 1.5"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

variable "datastore" {
  type        = string
  description = "vSphere datastore name"
}

variable "network_label" {
  type        = string
  description = "vSphere network label"
}

variable "folder" {
  type        = string
  description = "vSphere VM folder path"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
}

module "vm" {
  source = "./modules/vsphere-vm"

  datastore     = var.datastore
  network_label = var.network_label
  folder        = var.folder
  environment   = var.environment
}

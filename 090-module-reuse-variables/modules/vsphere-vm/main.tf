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

resource "vsphere_virtual_machine" "vm" {
  name             = "app-vm-${var.environment}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.ds.id
  folder           = var.folder

  num_cpus = 2
  memory   = 4092

  network_interface {
    network_id = data.vsphere_network.net.id
  }

  disk {
    label = "disk0"
    size  = 40
  }
}

data "vsphere_datastore" "ds" {
  name = var.datastore
}

data "vsphere_network" "net" {
  name = var.network_label
}

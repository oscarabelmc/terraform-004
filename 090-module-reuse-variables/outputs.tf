output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}

output "vm_folder" {
  value = var.folder
}

output "module_note" {
  value = "Hardcoded values converted to variables — reuse across Lab, QA, Prod via tfvars."
}

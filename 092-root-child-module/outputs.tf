output "server_count" {
  value = 5
}

output "module_note" {
  value = "main.tf is the root (calling) module. ./modules/local-cluster is a local child module."
}

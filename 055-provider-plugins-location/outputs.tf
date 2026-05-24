output "provider_path" {
  description = "Location of downloaded provider plugins"
  value       = "${path.module}/.terraform/providers/"
}

output "plugin_storage_note" {
  value = "Providers are downloaded to .terraform/providers/<registry>/<namespace>/<type>/<version>/<os_arch>/"
}

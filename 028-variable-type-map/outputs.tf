output "selected_region" {
  description = "The chosen deployment region"
  value       = var.region
}

output "resolved_image" {
  description = "The image ID resolved from the region map"
  value       = var.image[var.region]
}

output "all_images" {
  description = "All available region→image mappings"
  value       = var.image
}

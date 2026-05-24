output "instance_name" {
  value = google_compute_instance.web.name
}

output "attached_disk_instance" {
  value = google_compute_attached_disk.data.instance
}

output "creation_order" {
  value = "Instance created first (no dependencies), then attached disk (depends on instance)."
}

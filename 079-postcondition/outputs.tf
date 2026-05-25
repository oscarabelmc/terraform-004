output "instance_name" {
  value = google_compute_instance.web.name
}

output "public_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

output "postcondition_note" {
  value = "Postcondition in lifecycle block validates nat_ip is assigned after creation."
}

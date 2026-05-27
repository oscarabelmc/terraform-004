terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

variable "existing_disk" {
  type = string
}

resource "google_compute_instance" "web" {
  name         = "order-web-1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_attached_disk" "data" {
  instance = google_compute_instance.web.name
  disk     = var.existing_disk
}

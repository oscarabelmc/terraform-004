terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_compute_instance" "web" {
  name         = "postcondition-demo"
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

  lifecycle {
    postcondition {
      condition     = self.network_interface[0].access_config[0].nat_ip != ""
      error_message = "Instance did not receive a public IP address."
    }
  }
}

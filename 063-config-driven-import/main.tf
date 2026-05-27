terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

import {
  to = google_storage_bucket.data_lake
  id = "imported-data-lake"
}

resource "google_storage_bucket" "data_lake" {
  name     = "imported-data-lake"
  location = "US"
}

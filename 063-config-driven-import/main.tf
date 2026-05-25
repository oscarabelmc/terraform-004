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
  id = "bk-existing-bucket"
}

resource "google_storage_bucket" "data_lake" {
  name     = "bk-existing-bucket"
  location = "US"
}

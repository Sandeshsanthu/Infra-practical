terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.17.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "project-d1a95002-78b0-493b-b7e"
}

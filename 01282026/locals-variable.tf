locals {
  zone = "${var.region}-a"
}
resource "google_compute_instance" "example" {
  name         = "example-vm"
  machine_type = "e2-micro"
  zone = local.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

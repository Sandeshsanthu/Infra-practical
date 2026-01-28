resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-standard"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
lifecycle {
    create_before_destroy = true
  }
allow_stopping_for_update = true
  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }
 network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

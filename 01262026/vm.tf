resource "google_compute_instance" "default" {
name = "vm-for-test"
machine_type = "n2-standard-2"
zone = "us-central1-a"

boot_disk {

initialize_params { 
image = "debian-cloud/debian-11"
labels = {
my_label = "value"
}
}
}
network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "329313374630-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
allow_stopping_for_update = true
}

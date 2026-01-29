resource "google_compute_firewall" "app_ingress"{
    name = "app-allow-tcp"
    network= "default"
    direction = "INGRESS"
    priority = 1000

    target_tags = ["app"]
    source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = [for p in var.allowed_ports : tostring(p)]
  }
}

#main
resource "google_storage_bucket" "staticccccc-sites-sandesh" {
name = "sandeshssssss"
location = "EU"
force_destroy = true

uniform_bucket_level_access = true

lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      days_since_noncurrent_time = 3
      send_age_if_zero = false
    }
  }
}

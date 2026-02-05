locals {
composer_envs = {
dev  = "example-composer-env-tf-c3-dev"
prod = "example-composer-env-tf-c3-test"
}
}
resource "google_project_iam_member" "composer-worker" {
  project = "project-d1a95002-78b0-493b-b7e"
  role    = "roles/composer.worker"
  member  = "serviceAccount:composer-env-account@project-d1a95002-78b0-493b-b7e.iam.gserviceaccount.com"
}

resource "google_composer_environment" "test" {
  for_each = local.composer_envs
  name   = each.value
  region = "us-central1"
  config {

    software_config {
      image_version = "composer-3-airflow-2"
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      triggerer {
        cpu        = 0.5
        memory_gb  = 1
        count      = 1
      }
      dag_processor {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 2
        storage_gb = 1
      }
      worker {
        cpu = 0.5
        memory_gb  = 2
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }

    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      service_account = "composer-env-account@project-d1a95002-78b0-493b-b7e.iam.gserviceaccount.com"
    }
  }
}



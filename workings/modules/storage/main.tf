# modules/storage/main.tf
resource "google_storage_bucket" "logs" {
  name          = "${var.project_id}-${var.environment}-logs"
  location      = var.region
  force_destroy = var.environment != "prod" # Prevent accidental deletion in prod
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "tenant_data" {
  name          = "${var.project_id}-tenant_data-${var.environment}"
  location      = var.region
  storage_class               = "STANDARD"
  force_destroy = var.environment != "prod"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

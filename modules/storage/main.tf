# modules/storage/main.tf
resource "google_storage_bucket" "tenant_data" { #crl_data_store_prd_eu_west_2_flax
  name                        = "${var.project_id}-tenant-data-${var.environment}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "logs" { #crl_log_store_eu_west_2_prd
  name                        = "${var.project_id}-logs-${var.environment}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

"tf-state-store"

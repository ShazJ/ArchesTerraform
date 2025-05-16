resource "google_kms_key_ring" "key_ring" {
  project  = var.project_id
  name     = var.name
  location = var.location
}
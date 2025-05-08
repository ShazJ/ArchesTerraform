resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.name
  network = var.network
  region  = var.region
}
resource "google_compute_route" "route" {
  project     = var.project_id
  name        = var.name
  network     = var.network
  dest_range  = var.dest_range
  priority    = var.priority
  description = var.description
}
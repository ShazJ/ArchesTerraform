resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.name
  network = var.network
  region  = var.region
}

resource "google_compute_router_nat" "nats" {
  name                               = "${var.name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  min_ports_per_vm = 64
}
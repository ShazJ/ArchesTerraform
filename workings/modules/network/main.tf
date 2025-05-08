resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc-${var.environment}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-${var.environment}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "k8s_ingress" {
  name    = "${var.project_id}-${var.environment}-k8s-ingress"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["10250", "443", "15017", "8080", "15000"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust for security in production
  target_tags   = ["${var.project_id}-${var.environment}-k8s-vm"]
}
# sji pretty sure there's only 1 subnet here - if not name will incude count
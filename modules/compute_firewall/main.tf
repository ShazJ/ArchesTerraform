resource "google_compute_firewall" "firewall" {
  project       = var.project_id
  name          = var.name
  network       = var.network
  direction     = var.direction
  priority      = var.priority
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
  description   = var.description

  dynamic "allow" {
    for_each = var.allow
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }
}
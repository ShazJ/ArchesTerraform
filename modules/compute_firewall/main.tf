resource "google_compute_firewall" "firewall" {
  project       = var.project_id
  name          = var.name
  network       = var.network
  direction     = var.direction
  priority      = var.priority
  source_ranges = var.source_ranges
  description   = var.description
  target_tags   = length(var.target_tags) > 0 ? var.target_tags : null

  dynamic "allow" {
    for_each = var.allow
    content {
      protocol = allow.value.protocol
      ports    = length(allow.value.ports) > 0 ? allow.value.ports : null
    }
  }
}
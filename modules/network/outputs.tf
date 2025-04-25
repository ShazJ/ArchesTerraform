# modules/network/outputs.tf
output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

output "subnet_self_links" {
  value = google_compute_subnetwork.subnet[*].self_link
} #?sji

output "network_self_link" {
  value = google_compute_network.vpc.self_link
} #?sji
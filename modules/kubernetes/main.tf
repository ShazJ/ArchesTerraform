resource "google_compute_instance" "k8s_vm" {
  name         = "${var.project_id}-${var.environment}-k8s-vm"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      # Install prerequisites for Kubernetes
      apt-get update
      apt-get install -y docker.io
      # Additional Kubernetes setup can be added here
    EOF
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  tags = ["${var.project_id}-${var.environment}-k8s-vm"]
}
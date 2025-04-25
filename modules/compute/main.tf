# modules/compute/main.tf
resource "google_compute_instance" "k8s_vm" {
  name         = "${var.project_id}-k8s-vm-${var.environment}"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  service_account {
    email  = var.vm_sa_email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    curl -s https://get.k3s.io | sh -
    EOT
}

# resource "google_compute_instance" "default" {
#   name         = var.instance_name
#   machine_type = var.machine_type
#   zone         = var.zone

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network    = var.network
#     subnetwork = var.subnetwork
#     access_config {}
#   }
# }


resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = "${var.environment}-vm"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {}
  }

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}
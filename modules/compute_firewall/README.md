# Compute Firewall Module

This module creates a Google Compute Firewall rule.

## Usage

```hcl
module "compute_firewall" {
  source         = "./modules/compute_firewall"
  project_id     = "coral-370212"
  name           = "allow-ingress-coral-prd"
  network        = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
  direction      = "INGRESS"
  priority       = 1000
  source_ranges  = ["172.16.0.0/28"]
  target_tags    = ["gke-k8s-coral-prd-np-tf-8r35wt"]
  allow          = [{
    protocol     = "tcp"
    ports        = ["10250", "443", "15017", "8080", "15000"]
  }]
}
```

## Import Existing Resource

To import existing firewall rules, run:

```bash
terraform import module.compute_firewall["coral_prd"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/allow-ingress-coral-prd
terraform import module.compute_firewall["coral_stg"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/allow-ingress-coral-stg
# Compute Subnetwork Module

This module creates a Google Compute Subnetwork.

## Usage

```hcl
module "compute_subnetwork" {
  source                     = "./modules/compute_subnetwork"
  project_id                 = "coral-370212"
  name                       = "coral-subnetwork-prd"
  network                    = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
  region                     = "europe-west2"
  ip_cidr_range              = "10.2.0.0/16"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"
  secondary_ip_ranges        = [
    {
      range_name    = "services-range"
      ip_cidr_range = "192.168.0.0/20"
    },
    {
      range_name    = "pod-ranges"
      ip_cidr_range = "192.168.64.0/20"
    },
    {
      range_name    = "gke-coral-cluster-pods-f3c8dd1b"
      ip_cidr_range = "10.196.0.0/14"
    },
    {
      range_name    = "gke-coral-cluster-services-f3c8dd1b"
      ip_cidr_range = "10.200.0.0/20"
    }
  ]
}
```

## Import Existing Resource

To import existing subnetworks, run:

```bash
terraform import module.compute_subnetwork_prd.google_compute_subnetwork.subnetwork projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork-prd
terraform import module.compute_subnetwork.google_compute_subnetwork.subnetwork projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork
```

## Inputs

| Name                       | Description                                    | Type   | Default |
|----------------------------|------------------------------------------------|--------|---------|
| project_id                 | The ID of the GCP project                      | string | -       |
| name                       | The name of the subnetwork                     | string | -       |
| network                    | The network for the subnetwork                 | string | -       |
| region                     | The region for the subnetwork                  | string | -       |
| ip_cidr_range              | The primary IP CIDR range                      | string | -       |
| private_ip_google_access   | Enable private IP Google access                | bool   | -       |
| private_ipv6_google_access | Private IPv6 Google access setting             | string | -       |
| purpose                    | The purpose (e.g., PRIVATE)                    | string | -       |
| stack_type                 | The stack type (e.g., IPV4_ONLY)               | string | -       |
| secondary_ip_ranges        | List of secondary IP ranges                    | list   | -       |

## Outputs

| Name             | Description                                    |
|------------------|------------------------------------------------|
| subnetwork_name  | The name of the created subnetwork             |
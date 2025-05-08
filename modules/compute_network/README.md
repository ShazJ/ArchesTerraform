# Compute Network Module

This module creates a Google Compute Network.

## Usage

```hcl
module "compute_network" {
  source                              = "./modules/compute_network"
  project_id                          = "coral-370212"
  name                                = "coral-network-prd"
  auto_create_subnetworks             = false
  routing_mode                        = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}
```

## Import Existing Resource

To import existing networks, run:

```bash
terraform import module.compute_network_prd.google_compute_network.network projects/coral-370212/global/networks/coral-network-prd
terraform import module.compute_network.google_compute_network.network projects/coral-370212/global/networks/coral-network
```

## Inputs

| Name                              | Description                                    | Type   | Default |
|-----------------------------------|------------------------------------------------|--------|---------|
| project_id                        | The ID of the GCP project                      | string | -       |
| name                              | The name of the network                        | string | -       |
| auto_create_subnetworks           | Whether to auto-create subnetworks             | bool   | -       |
| routing_mode                      | The routing mode (e.g., REGIONAL)              | string | -       |
| network_firewall_policy_enforcement_order | Firewall policy enforcement order      | string | -       |

## Outputs

| Name            | Description                                    |
|-----------------|------------------------------------------------|
| network_name    | The name of the created network                |
| network_self_link | The self-link of the created network         |
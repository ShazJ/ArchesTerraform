# Compute Address Module

This module creates a Google Compute Address.

## Usage

```hcl
module "compute_address" {
  source         = "./modules/compute_address"
  project_id     = "coral-370212"
  region         = "europe-west2"
  name           = "istio-default-ingress-coral-prd"
  address        = "34.142.75.32"
  address_type   = "EXTERNAL"
  network_tier   = "PREMIUM"
}
```

## Import Existing Resource

To import existing addresses, run:

```bash
terraform import module.compute_address["istio_prd"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/istio-default-ingress-coral-prd
terraform import module.compute_address["istio_stg"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/istio-default-ingress-coral-stg
terraform import module.compute_address["nat_auto_1"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/nat-auto-ip-6086885-2-1720490595712813
terraform import module.compute_address["nat_auto_2"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/nat-auto-ip-15970522-0-1676784907194161
```

## Inputs

| Name           | Description                                    | Type   | Default |
|----------------|------------------------------------------------|--------|---------|
| project_id     | The ID of the GCP project                      | string | -       |
| region         | The region for the address                     | string | -       |
| name           | The name of the address                        | string | -       |
| address        | The static IP address                          | string | -       |
| address_type   | The type of address (e.g., EXTERNAL)           | string | -       |
| network_tier   | The network tier (e.g., PREMIUM)               | string | -       |
| purpose        | The purpose of the address (e.g., NAT_AUTO)    | string | null    |

## Outputs

| Name     | Description                                    |
|----------|------------------------------------------------|
| address  | The IP address of the created address          |
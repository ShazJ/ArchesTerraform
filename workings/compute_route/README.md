# Compute Route Module

This module creates a Google Compute Route.

## Usage

```hcl
module "compute_route" {
  source      = "./modules/compute_route"
  project_id  = "coral-370212"
  name        = "peering-route-2d78a0e4bac140d8"
  network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network"
  dest_range  = "172.16.0.0/28"
  priority    = 0
  description = "Auto generated route via peering [gke-n3160d8fda93cc2900d2-6468-d2c7-peer]."
}
```

## Import Existing Resource

To import existing routes, run:

```bash
terraform import module.compute_route["peering_2d78a0e4bac140d8"].google_compute_route.route projects/coral-370212/global/routes/peering-route-2d78a0e4bac140d8
terraform import module.compute_route["peering_6417c1f2b7f61256"].google_compute_route.route projects/coral-370212/global/routes/peering-route-6417c1f2b7f61256
```

## Inputs

| Name        | Description                                    | Type   | Default |
|-------------|------------------------------------------------|--------|---------|
| project_id  | The ID of the GCP project                      | string | -       |
| name        | The name of the route                          | string | -       |
| network     | The network for the route                      | string | -       |
| dest_range  | The destination CIDR range                     | string | -       |
| priority    | The priority of the route                      | number | -       |
| description | Description of the route                       | string | -       |

## Outputs

| Name       | Description                                    |
|------------|------------------------------------------------|
| route_name | The name of the created route                  |
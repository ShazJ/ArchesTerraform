# Compute Router Module

This module creates a Google Compute Router.

## Usage

```hcl
module "compute_router" {
  source      = "./modules/compute_router"
  project_id  = "coral-370212"
  name        = "coral-network-router-prd"
  network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
  region      = "europe-west2"
}
```

## Import Existing Resource

To import existing routers, run:

```bash
terraform import module.compute_router["prd"].google_compute_router.router projects/coral-370212/regions/europe-west2/routers/coral-network-router-prd
terraform import module.compute_router["stg"].google_compute_router.router projects/coral-370212/regions/europe-west2/routers/coral-network-router
```

## Inputs

| Name       | Description                                    | Type   | Default |
|------------|------------------------------------------------|--------|---------|
| project_id | The ID of the GCP project                      | string | -       |
| name       | The name of the router                         | string | -       |
| network    | The network for the router                     | string | -       |
| region     | The region for the router                      | string | -       |

## Outputs

| Name         | Description                                    |
|--------------|------------------------------------------------|
| router_name  | The name of the created router                 |
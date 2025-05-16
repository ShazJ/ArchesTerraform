# KMS Key Ring Module

This module creates a Google KMS Key Ring.

## Usage

```hcl
module "kms_key_ring" {
  source      = "./modules/kms_key_ring"
  project_id  = "coral-370212"
  name        = "data-store-keyring-uat-prd"
  location    = "europe-west2"
}
```

## Import Existing Resource

To import existing key rings, run:

```bash
terraform import module.kms_key_ring["data_store_uat_prd"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat-prd
terraform import module.kms_key_ring["data_store_uat"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat
terraform import module.kms_key_ring["terraform_state"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/terraform-state-keyring
```

## Inputs

| Name       | Description                                    | Type   | Default |
|------------|------------------------------------------------|--------|---------|
| project_id | The ID of the GCP project                      | string | -       |
| name       | The name of the key ring                       | string | -       |
| location   | The location for the key ring                  | string | -       |

## Outputs

| Name           | Description                                    |
|----------------|------------------------------------------------|
| key_ring_name  | The name of the created key ring               |
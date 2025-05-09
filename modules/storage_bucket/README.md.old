# Storage Bucket Module

This module creates a Google Storage Bucket.

## Usage

```hcl
module "storage_bucket" {
  source                     = "./modules/storage_bucket"
  project_id                 = "coral-370212"
  name                       = "crl-data-store-prd-eu-west-2-flax"
  location                   = "EUROPE-WEST2"
  storage_class              = "STANDARD"
  force_destroy              = false
  public_access_prevention   = "enforced"
  uniform_bucket_level_access = true
}
```

## Import Existing Resource

To import existing buckets, run:

```bash
terraform import module.storage_bucket["data_store_prd"].google_storage_bucket.bucket crl-data-store-prd-eu-west-2-flax
terraform import module.storage_bucket["data_store_uat_prd"].google_storage_bucket.bucket crl-data-store-uat-eu-west-2-prd
terraform import module.storage_bucket["data_store_uat"].google_storage_bucket.bucket crl-data-store-uat-eu-west-2
terraform import module.storage_bucket["log_store_prd"].google_storage_bucket.bucket crl-log-store-eu-west-2-prd
terraform import module.storage_bucket["prd_state_store_uat"].google_storage_bucket.bucket crl-prd-state-store-uat-eu-west-2
terraform import module.storage_bucket["state_store_uat"].google_storage_bucket.bucket crl-state-store-uat-eu-west-2
terraform import module.storage_bucket["artifacts_us"].google_storage_bucket.bucket artifacts.coral-370212.appspot.com
terraform import module.storage_bucket["artifacts_eu"].google_storage_bucket.bucket eu.artifacts.coral-370212.appspot.com
```

## Inputs

| Name                       | Description                                    | Type   | Default |
|----------------------------|------------------------------------------------|--------|---------|
| project_id                 | The ID of the GCP project                      | string | -       |
| name                       | The name of the bucket                         | string | -       |
| location                   | The location of the bucket                     | string | -       |
| storage_class              | The storage class (e.g., STANDARD)             | string | -       |
| force_destroy              | Allow force destroy of the bucket              | bool   | -       |
| public_access_prevention   | Public access prevention setting               | string | -       |
| uniform_bucket_level_access | Enable uniform bucket-level access             | bool   | -       |
| cors                       | CORS configuration                             | list   | []      |
| encryption                 | Encryption configuration                       | object | null    |
| logging                    | Logging configuration                          | object | null    |

## Outputs

| Name         | Description                                    |
|--------------|------------------------------------------------|
| bucket_name  | The name of the created bucket                 |
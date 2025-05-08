# Service Account Module

This module creates a Google Service Account.

## Usage

```hcl
module "service_account" {
  source         = "./modules/service_account"
  project_id     = "coral-370212"
  account_id     = "coral-arches-k8s-coral-prd"
  display_name   = "coral-arches-k8s coral-prd"
  description    = "Its IAM role(s) will specify the access-levels that the GKE node(s) may have"
}
```

## Import Existing Resource

To import existing service accounts, run:

```bash
terraform import module.service_account["arches_k8s_prd"].google_service_account.account projects/coral-370212/serviceAccounts/coral-arches-k8s-coral-prd@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["arches_k8s_stg"].google_service_account.account projects/coral-370212/serviceAccounts/coral-arches-k8s-coral-stg@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["arches_uat_prd"].google_service_account.account projects/coral-370212/serviceAccounts/coral-arches-uat-prd@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["arches_uat"].google_service_account.account projects/coral-370212/serviceAccounts/coral-arches-uat@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["ci_prd"].google_service_account.account projects/coral-370212/serviceAccounts/coral-ci-prd@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["ci"].google_service_account.account projects/coral-370212/serviceAccounts/coral-ci@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["flux_prd"].google_service_account.account projects/coral-370212/serviceAccounts/coral-flux-prd@coral-370212.iam.gserviceaccount.com
terraform import module.service_account["gl_ci_prd"].google_service_account.account projects/coral-370212/serviceAccounts/coral-gl-ci-prd@coral-370212.iam.gserviceaccount.com
```

## Inputs

| Name           | Description                                    | Type   | Default |
|----------------|------------------------------------------------|--------|---------|
| project_id     | The ID of the GCP project                      | string | -       |
| account_id     | The account ID of the Service Account          | string | -       |
| display_name   | The display name of the Service Account        | string | -       |
| description    | Description of the Service Account             | string | null    |

## Outputs

| Name   | Description                                    |
|--------|------------------------------------------------|
| email  | The email of the created Service Account       |
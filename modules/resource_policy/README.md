# Compute Resource Policy Module

This module creates a Google Compute Resource Policy.

## Usage

```hcl
module "compute_resource_policy" {
  source      = "./modules/compute_resource_policy"
  project_id  = "coral-370212"
  name        = "coral-postgres"
  region      = "europe-west2"
  snapshot_schedule_policy = {
    retention_policy = {
      max_retention_days    = 14
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    schedule = {
      daily_schedule = {
        days_in_cycle = 1
        start_time    = "19:00"
      }
    }
    snapshot_properties = {
      labels = {
        purpose = "db"
      }
      storage_locations = ["europe-west2"]
    }
  }
}
```

## Import Existing Resource

To import the existing resource policy, run:

```bash
terraform import module.compute_resource_policy.google_compute_resource_policy.policy projects/coral-370212/regions/europe-west2/resourcePolicies/coral-postgres
```

## Inputs

| Name                    | Description                                    | Type   | Default |
|-------------------------|------------------------------------------------|--------|---------|
| project_id              | The ID of the GCP project                      | string | -       |
| name                    | The name of the resource policy                | string | -       |
| region                  | The region for the resource policy             | string | -       |
| snapshot_schedule_policy | Snapshot schedule policy configuration         | object | -       |

## Outputs

| Name         | Description                                    |
|--------------|------------------------------------------------|
| policy_name  | The name of the created resource policy        |
# Artifact Registry Module

This module creates a Google Artifact Registry repository.

## Usage

```hcl
module "artifact_registry" {
  source               = "./modules/artifact_registry"
  project_id           = "coral-370212"
  repository_id        = "arches"
  location             = "europe-west2"
  description          = "Core Arches images for Coral (see *static* for deployable)"
  format               = "DOCKER"
  mode                 = "STANDARD_REPOSITORY"
  cleanup_policy_dry_run = true
}
```

## Import Existing Resource

To import an existing repository, run:

```bash
terraform import module.artifact_registry["arches"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/arches
terraform import module.artifact_registry["arches_prd"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/arches-prd
terraform import module.artifact_registry["archesdata_prd"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/archesdata-prd
```

## Inputs

| Name                    | Description                                    | Type   | Default |
|-------------------------|------------------------------------------------|--------|---------|
| project_id              | The ID of the GCP project                      | string | -       |
| repository_id           | The ID of the repository                       | string | -       |
| location                | The location of the repository                 | string | -       |
| description             | Description of the repository                  | string | -       |
| format                  | The format of the repository (e.g., DOCKER)    | string | -       |
| mode                    | The mode of the repository                     | string | -       |
| cleanup_policy_dry_run  | Enable cleanup policy dry run                  | bool   | -       |

## Outputs

| Name            | Description                                    |
|-----------------|------------------------------------------------|
| repository_name | The name of the created repository             |
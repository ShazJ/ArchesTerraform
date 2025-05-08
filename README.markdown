# Terraform Project: Coral GCP Infrastructure

This Terraform project manages Google Cloud Platform (GCP) infrastructure for the Coral project (`coral-370212`), including Artifact Registry repositories, Compute Addresses, Firewalls, Storage Buckets, Service Accounts, Networks, Subnetworks, Routers, Routes, Resource Policies, and KMS Key Rings.

## Structure

- `main.tf`: Root module calling all resource modules.
- `variables.tf`: Variable definitions, including maps for resources.
- `outputs.tf`: Outputs for resource details.
- `providers.tf`: Google provider configuration.
- `terraform.tfvars`: Variable values.
- `modules/`: Contains modules for each resource type (`artifact_registry`, `compute_address`, `compute_firewall`, `storage_bucket`, `service_account`, `compute_network`, `compute_subnetwork`, `compute_router`, `compute_route`, `compute_resource_policy`, `kms_key_ring`).

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Importing Existing Resources

Use the following commands to import existing resources:

### Artifact Registry Repositories
```bash
terraform import module.artifact_registry["arches"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/arches
terraform import module.artifact_registry["arches_prd"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/arches-prd
terraform import module.artifact_registry["archesdata_prd"].google_artifact_registry_repository.repository projects/coral-370212/locations/europe-west2/repositories/archesdata-prd
```

### Compute Addresses
```bash
terraform import module.compute_address["istio_prd"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/istio-default-ingress-coral-prd
terraform import module.compute_address["istio_stg"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/istio-default-ingress-coral-stg
terraform import module.compute_address["nat_auto_1"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/nat-auto-ip-6086885-2-1720490595712813
terraform import module.compute_address["nat_auto_2"].google_compute_address.address projects/coral-370212/regions/europe-west2/addresses/nat-auto-ip-15970522-0-1676784907194161
```

### Compute Firewalls
```bash
terraform import module.compute_firewall["coral_prd"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/allow-ingress-coral-prd
terraform import module.compute_firewall["coral_stg"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/allow-ingress-coral-stg
terraform import module.compute_firewall["default_icmp"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/default-allow-icmp
terraform import module.compute_firewall["default_internal"].google_compute_firewall.firewall projects/coral-370212/global/firewalls/default-allow-internal
```

### Storage Buckets
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

### Service Accounts
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

### Compute Networks
```bash
terraform import module.compute_network_prd.google_compute_network.network projects/coral-370212/global/networks/coral-network-prd
terraform import module.compute_network.google_compute_network.network projects/coral-370212/global/networks/coral-network
```

### Compute Subnetworks
```bash
terraform import module.compute_subnetwork_prd.google_compute_subnetwork.subnetwork projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork-prd
terraform import module.compute_subnetwork.google_compute_subnetwork.subnetwork projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork
```

### Compute Routers
```bash
terraform import module.compute_router["prd"].google_compute_router.router projects/coral-370212/regions/europe-west2/routers/coral-network-router-prd
terraform import module.compute_router["stg"].google_compute_router.router projects/coral-370212/regions/europe-west2/routers/coral-network-router
```

### Compute Routes
```bash
terraform import module.compute_route["peering_2d78a0e4bac140d8"].google_compute_route.route projects/coral-370212/global/routes/peering-route-2d78a0e4bac140d8
terraform import module.compute_route["peering_6417c1f2b7f61256"].google_compute_route.route projects/coral-370212/global/routes/peering-route-6417c1f2b7f61256
```

### Compute Resource Policy
```bash
terraform import module.compute_resource_policy.google_compute_resource_policy.policy projects/coral-370212/regions/europe-west2/resourcePolicies/coral-postgres
```

### KMS Key Rings
```bash
terraform import module.kms_key_ring["data_store_uat_prd"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat-prd
terraform import module.kms_key_ring["data_store_uat"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat
terraform import module.kms_key_ring["terraform_state"].google_kms_key_ring.key_ring projects/coral-370212/locations/europe-west2/keyRings/terraform-state-keyring
```

## Notes
- Ensure referenced KMS keys, networks, and other dependencies exist before applying.
- The `logging.log_bucket` for some buckets references `log-store-eu-west-2`, which must exist or be managed elsewhere.
- Routes are auto-generated via peering and may require careful management to avoid conflicts.
# Container Cluster Module

This module creates a Google Kubernetes Engine (GKE) cluster.

## Usage

```hcl
module "container_cluster" {
  source     = "./modules/container_cluster"
  project_id = "coral-370212"
  name       = "k8s-coral-prd"
  location   = "europe-west2-a"
  network    = "projects/coral-370212/global/networks/coral-network-prd"
  subnetwork = "projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork-prd"
  # ... other configurations
}
```

## Import Existing Resource

To import existing clusters, run:

```bash
terraform import module.container_cluster["prd"].google_container_cluster.cluster coral-370212/europe-west2-a/k8s-coral-prd
terraform import module.container_cluster["stg"].google_container_cluster.cluster coral-370212/europe-west2-a/k8s-coral-stg
```

## Inputs

| Name                           | Description                                    | Type   | Default |
|--------------------------------|------------------------------------------------|--------|---------|
| project_id                     | The ID of the GCP project                      | string | -       |
| name                           | The name of the GKE cluster                    | string | -       |
| location                       | The location (zone or region) of the cluster   | string | -       |
| network                        | The network for the cluster                    | string | -       |
| subnetwork                     | The subnetwork for the cluster                 | string | -       |
| node_config                    | Node configuration                             | object | -       |
| ip_allocation_policy           | IP allocation policy                           | object | -       |
| addons_config                  | Addons configuration                           | object | -       |
| cluster_autoscaling            | Cluster autoscaling configuration              | object | -       |
| cluster_telemetry              | Cluster telemetry configuration                | object | -       |
| database_encryption            | Database encryption configuration              | object | -       |
| default_max_pods_per_node      | Default maximum pods per node                  | number | -       |
| default_snat_status            | Default SNAT status                            | object | -       |
| description                    | Description of the cluster                     | string | -       |
| enable_shielded_nodes          | Enable shielded nodes                          | bool   | -       |
| initial_node_count             | Initial node count                             | number | -       |
| logging_config                 | Logging configuration                          | object | -       |
| maintenance_policy             | Maintenance policy                             | object | -       |
| master_auth                    | Master authentication configuration            | object | -       |
| master_authorized_networks_config | Master authorized networks configuration   | object | -       |
| monitoring_config              | Monitoring configuration                       | object | -       |
| network_policy                 | Network policy configuration                   | object | -       |
| networking_mode                | Networking mode (e.g., VPC_NATIVE)             | string | -       |
| node_pool_defaults             | Node pool defaults                             | object | -       |
| node_version                   | Node version                                   | string | -       |
| notification_config            | Notification configuration                     | object | -       |
| pod_security_policy_config     | Pod security policy configuration              | object | -       |
| private_cluster_config         | Private cluster configuration                  | object | -       |
| protect_config                 | Protect configuration                          | object | -       |
| release_channel                | Release channel                                | object | -       |
| security_posture_config        | Security posture configuration                 | object | -       |
| service_external_ips_config    | Service external IPs configuration             | object | -       |
| vertical_pod_autoscaling       | Vertical pod autoscaling configuration         | object | -       |
| workload_identity_config       | Workload identity configuration                | object | null    |

## Outputs

| Name         | Description                                    |
|--------------|------------------------------------------------|
| cluster_name | The name of the created GKE cluster            |
| endpoint     | The endpoint of the GKE cluster                |
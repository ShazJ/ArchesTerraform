# Linen Hall Infrastructure

# Terraform GCP Project
This project provisions GCP resources (VPC, subnets, storage, service accounts, VMs) across dev, uat, and prod environments using Terraform workspaces.

## Setup
1. Install Terraform (>= 1.5.0)
2. Authenticate with GCP: `gcloud auth application-default login`
3. Initialize Terraform: `terraform init`
4. Create workspaces: `bash scripts/init_workspaces.sh`
5. Apply configuration:
   - `terraform workspace select dev`
   - `terraform apply -var-file=environments/dev/terraform.tfvars`

## Structure
- `environments/`: Environment-specific configurations
- `modules/`: Reusable modules for network, storage, service accounts, and compute
- `scripts/`: Automation scripts
- `provider.tf`: GCP provider configuration
- `variables.tf`: Global variables
- `outputs.tf`: Global outputs


## GCP

Note that Compute Engine API and Google Container Registry API
must be enabled. Enable Kubernetes Engine API (containers.googleapis.com) and
Cloud Source Repositories API.

    terraform workspace select stg
    terraform plan
    terraform apply
    gcloud container clusters get-credentials linen-hall --region europe-west2

## Helm

    kubectl create namespace ingress
    kubectl create namespace jhub
    cd helm
    helmfile apply

# Notes

Had to open egress for letsencrypt (as IP not fixed) manually.

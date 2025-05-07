# Setup Environment

## Prerequisites
You must have the following installed locally to bootstrap this:
GitHub CLI (gh --version to check)
GCP CLI (gcloud version to check)
Authenticate to both.
Store the resultant bootstrap json somewhere sensible. We'd probably want to remove the bootstrap secret at some point to - todo sji

## Bootstrap Terraform
1. Update the /scrips/setup_tf config.env file with correct values
2. Manually run /scripts/setup_tf/create_bootstrap_sa.sh. This will create the bootstrap service account and store as GitHub secret.

## Terraform
### Environment Setup
Manually run Setup Terraform State (.github/workflows/setup-tf-state.yml) GitHub Action. This will create the service account needed for Terraform as well as the state bucket.


# Scribbles
## Github Secrets
GCP_PROJECT_ID
projectid-type-store-env-region
e.g. crl-data-store-uat-eu-west-2

#setup new project todo
create secrets
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
        SONAR_PROJECT_KEY: ${{ vars.SONAR_PROJECT_KEY }}
        SONAR_PROJECT_NAME: ${{ vars.SONAR_PROJECT_NAME }}
        SONAR_PROJECT_VERSION: ${{ vars.SONAR_PROJECT_VERSION }}

# Cleanup
## Destroy Environment
cd terraform
terraform destroy -var-file="environments/dev.tfvars"

## Delete State bucket  ??? sji
gsutil rm -r gs://terraform-state-bucket



# Deployment
cd ArchesTerraform/envs/dev

terraform fmt / lint
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Storage Buckets

## Data

## Logs

## Artifacts

## State
Terraform

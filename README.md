# Setup Environment

## Github Secrets
GCP_PROJECT_ID

## Terraform State
Create GCP_BOOTSTRAP_SA_KEY and store as GitHub secret.
Manually run Setup Terraform State Bucket GitHub Action.
The first run of the service account creation script will generate sa-tf-state-key.json. Add this key to GitHub Secrets as GCP_TF_STATE_SA_KEY.

# Scribbles
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

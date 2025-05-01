# wip sji

projectid-type-store-env-region
e.g. crl-data-store-uat-eu-west-2

#setup new project todo
create secrets
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
        SONAR_PROJECT_KEY: ${{ vars.SONAR_PROJECT_KEY }}
        SONAR_PROJECT_NAME: ${{ vars.SONAR_PROJECT_NAME }}
        SONAR_PROJECT_VERSION: ${{ vars.SONAR_PROJECT_VERSION }}

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

# Linen Hall Infrastructure

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

# This script creates a service account for managing a Google Cloud Storage bucket
# for Terraform state. It assigns necessary roles and generates a key for the service account.
# It also configures IAM permissions for the bucket and provides instructions for next steps.  
# State bucket is critical for Terraform operations, so ensure the service account has the right permissions.
# Run before bucket creation script!
# remember backup  -sji!

#!/bin/bash

# Exit on error
set -e

# Configuration variables
PROJECT_ID="<your-gcp-project-id>"              # Replace with your GCP project ID
BUCKET_NAME="<your-bucket-name>"                # e.g., my-project-tf-state
SERVICE_ACCOUNT_NAME="sa-tf-state"              # Name of the service account
SERVICE_ACCOUNT_EMAIL=""                        # Will be set dynamically
ADMIN_EMAIL="<admin-email>"                     # e.g., admin@example.com
DEVELOPER_EMAIL="<developer-email>"             # e.g., dev@example.com (optional)
KEY_FILE="sa-tf-state-key.json"                 # Output file for the service account key

# Validate inputs
if [[ -z "$PROJECT_ID" || -z "$BUCKET_NAME" || -z "$ADMIN_EMAIL" ]]; then
  echo "Error: PROJECT_ID, BUCKET_NAME, and ADMIN_EMAIL must be set."
  exit 1
fi

# Authenticate with GCP (assumes CI provides credentials or user is authenticated)
echo "Authenticating with GCP..."
if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
else
  echo "Warning: GOOGLE_APPLICATION_CREDENTIALS not set. Assuming default credentials."
fi

# Set the project
gcloud config set project "$PROJECT_ID"

# Check if service account exists
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
if gcloud iam service-accounts list --filter="email:${SERVICE_ACCOUNT_EMAIL}" --format="value(email)" | grep -q "$SERVICE_ACCOUNT_EMAIL"; then
  echo "Service account $SERVICE_ACCOUNT_EMAIL already exists. Skipping creation."
else
  echo "Creating service account $SERVICE_ACCOUNT_NAME..."
  gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
    --display-name="Terraform State Bucket Manager" \
    --description="Service account for managing Terraform state bucket"
fi

# Assign roles to the service account
echo "Assigning roles to service account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/storage.admin"
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/serviceusage.serviceUsageAdmin"

# Generate a key for the service account
echo "Generating service account key..."
if [[ -f "$KEY_FILE" ]]; then
  echo "Key file $KEY_FILE already exists. Skipping key creation."
else
  gcloud iam service-accounts keys create "$KEY_FILE" \
    --iam-account="$SERVICE_ACCOUNT_EMAIL"
  echo "Service account key saved to $KEY_FILE"
fi

# Set bucket IAM permissions (for bucket creation or updates)
echo "Configuring bucket IAM permissions..."
if gsutil ls "gs://$BUCKET_NAME" >/dev/null 2>&1; then
  gsutil iam ch "serviceAccount:$SERVICE_ACCOUNT_EMAIL:admin" "gs://$BUCKET_NAME"
  gsutil iam ch "user:$ADMIN_EMAIL:admin" "gs://$BUCKET_NAME"
  if [[ -n "$DEVELOPER_EMAIL" ]]; then
    gsutil iam ch "user:$DEVELOPER_EMAIL:objectCreator,objectViewer" "gs://$BUCKET_NAME"
  fi
else
  echo "Warning: Bucket gs://$BUCKET_NAME does not exist yet. Run bucket creation script first."
fi

echo "Service account $SERVICE_ACCOUNT_EMAIL is ready for Terraform state bucket management."
echo "Key file: $KEY_FILE"
echo "Next steps: Store $KEY_FILE securely in CI secrets and use it for bucket creation."
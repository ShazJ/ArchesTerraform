#!/bin/bash

# Exit on error
set -e

# Configuration variables
PROJECT_ID="<your-gcp-project-id>"  # Replace with your GCP project ID
BUCKET_NAME="<your-bucket-name>"    # e.g., my-project-tf-state
LOCATION="US"                       # Multi-region location (e.g., US, EU, ASIA)
ADMIN_EMAIL="<admin-email>"         # e.g., admin@example.com
DEVELOPER_EMAIL="<developer-email>" # e.g., dev@example.com (optional)

# Validate inputs
if [[ -z "$PROJECT_ID" || -z "$BUCKET_NAME" || -z "$ADMIN_EMAIL" ]]; then
  echo "Error: PROJECT_ID, BUCKET_NAME, and ADMIN_EMAIL must be set."
  exit 1
fi

# Authenticate with GCP (assumes CI provides credentials)
echo "Authenticating with GCP..."
if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
else
  echo "Warning: GOOGLE_APPLICATION_CREDENTIALS not set. Assuming default credentials."
fi

# Set the project
gcloud config set project "$PROJECT_ID"

# Check if Cloud Storage API is enabled
echo "Enabling Cloud Storage API if not already enabled..."
gcloud services enable storage.googleapis.com --project="$PROJECT_ID"

# Check if bucket exists
if gsutil ls "gs://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "Bucket gs://$BUCKET_NAME already exists. Skipping creation."
else
  echo "Creating bucket gs://$BUCKET_NAME..."
  gsutil mb -p "$PROJECT_ID" -l "$LOCATION" -b on "gs://$BUCKET_NAME"
fi

# Enable versioning
echo "Enabling versioning on bucket..."
gsutil versioning set on "gs://$BUCKET_NAME"

# Set lifecycle rule (optional: keep last 10 versions)
echo "Configuring lifecycle rules..."
cat <<EOF > lifecycle.json
{
  "rule": [
    {
      "action": { "type": "Delete" },
      "condition": { "numNewerVersions": 10 }
    }
  ]
}
EOF
gsutil lifecycle set lifecycle.json "gs://$BUCKET_NAME"
rm lifecycle.json

# Set IAM permissions
echo "Configuring IAM permissions..."
gsutil iam ch "user:$ADMIN_EMAIL:admin" "gs://$BUCKET_NAME"
if [[ -n "$DEVELOPER_EMAIL" ]]; then
  gsutil iam ch "user:$DEVELOPER_EMAIL:objectCreator,objectViewer" "gs://$BUCKET_NAME"
fi

echo "Bucket gs://$BUCKET_NAME is ready for Terraform state."
#!/bin/bash
set -e

# Log all output to a debug file (optional, helpful for Terraform apply logs)
exec 2>>/tmp/kms_debug.log
echo "Running check_key_ring.sh" >&2

# Read input
read -r input
echo "Input: $input" >&2

# Parse fields
PROJECT=$(echo "$input" | jq -r '.project')
LOCATION=$(echo "$input" | jq -r '.location')
NAME=$(echo "$input" | jq -r '.name')

echo "Parsed: project=$PROJECT location=$LOCATION name=$NAME" >&2

# Run gcloud
if gcloud kms keyrings describe "$NAME" --location="$LOCATION" --project="$PROJECT" >/dev/null 2>&1; then
  echo '{"exists": true}'
else
  echo '{"exists": false}'
fi

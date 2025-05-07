#!/bin/bash

# Usage check
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <secret_name> <path_to_file>"
  echo "Example: $0 BOOTSTRAP_KEY_FILE /home/ingrams/terraform-bootstrap.json"
  exit 1
fi

SECRET_NAME="$1"
FILE_PATH="$2"

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "❌ File not found: $FILE_PATH"
  exit 1
fi

# Get current repository
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

if [ -z "$REPO" ]; then
  echo "❌ Could not determine the current repository. Make sure you are in a valid GitHub repo directory."
  exit 1
fi

echo "📦 Using repository: $REPO"

# Read the file contents
SECRET_VALUE=$(<"$FILE_PATH")

# Store the secret using GitHub CLI
echo "$SECRET_VALUE" | gh secret set "$SECRET_NAME" --repo "$REPO"

# Confirmation
if [ $? -eq 0 ]; then
  echo "✅ Secret '$SECRET_NAME' successfully added to $REPO"
else
  echo "❌ Failed to add secret"
fi

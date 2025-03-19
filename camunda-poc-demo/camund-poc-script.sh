#!/bin/bash

# Configuration
REPO_DIR= https://github.com/Menzi1965/Camunda-POC.git
DEPLOY_ENDPOINT=http://localhost:8080/deployment/create  # Local deploy API
TAR_FILE="/tmp/deploy-$(date +%s).tar.gz"  # Unique filename

# Step 1: Navigate to the repo and pull the latest changes
cd "$REPO_DIR" || exit
git pull origin main  # Ensure latest changes are fetched
LATEST_COMMIT=$(git rev-parse HEAD)
echo "Latest commit: $LATEST_COMMIT"
# Step 2: Archive the latest commit
git archive --format=tar.gz -o "$TAR_FILE" HEAD
echo "Created archive: $TAR_FILE"

# Step 3: Send the archive to the application's deploy endpoint
RESPONSE=$(curl -s -X POST "$DEPLOY_ENDPOINT" \
    -H "Content-Type: multipart/form-data" \
    -F "file=@$TAR_FILE" \
    -F "commit=$LATEST_COMMIT")

echo "Deployment response: $RESPONSE"

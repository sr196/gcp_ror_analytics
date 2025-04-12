#!/bin/bash
#set -x

# Accept GCS file path as the first argument
GCS_FILE_PATH=$1

# Extract bucket name and object name from the GCS path
BUCKET_NAME=$(echo "$GCS_FILE_PATH" | sed -E 's|gs://([^/]+)/.*|\1|')
OBJECT_NAME=$(echo "$GCS_FILE_PATH" | sed -E 's|gs://[^/]+/(.*)|\1|')

# Authenticate and download the file using gsutil
echo "Converting $OBJECT_NAME from bucket $BUCKET_NAME to new-line delimited JSON"
gsutil cat "$GCS_FILE_PATH" | jq -c '.[]' | gsutil cp - "${GCS_FILE_PATH}.nd"

echo "Operation Completed.  Output File: ${GCS_FILE_PATH}.nd"
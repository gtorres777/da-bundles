#!/bin/bash

set -e

# Remove Databricks CLI if present
DATABRICKS_BINARY='/usr/local/bin/databricks'
if [ -f "$DATABRICKS_BINARY" ]; then
    sudo rm "$DATABRICKS_BINARY"
fi


#echo "Installing Databricks CLI"
curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

#Verify Databricks CLI version
echo "Databricks version:"
databricks -v

# Get Branch
BRANCH="${GITHUB_REF#refs/heads/}"

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    JOBS="*"
else
    source .github/scripts/check_diff.sh
    JOBS="${CHANGE_DIR_ARRAY[@]}"
    echo "Changes detected in following jobs:"
    echo "$JOBS"
fi

#Export Variables
export DATABRICKS_TOKEN
export DATABRICKS_HOST
export BRANCH
export JOBS


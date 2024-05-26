#!/bin/bash

set -e

BRANCH="${GITHUB_REF#refs/heads/}"

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    JOBS="*"
    DATABRICKS_BUNDLE_ENV="PROD"
else
    source .github/scripts/check_diff.sh
    JOBS="${CHANGE_DIR_ARRAY[@]}"
    DATABRICKS_BUNDLE_ENV="DEV"
fi

echo "Databricks Bundle Deploy"
echo ""

for dir in $JOBS; do
    if [[ "$dir" == @(.github|Terraform|DAB) ]]; then
        echo "Skip: $dir"
        echo ""
        continue
    fi
    cd $dir
    echo "Job: $dir Deployment"
    databricks bundle deploy -t "$DATABRICKS_BUNDLE_ENV"
    echo ""
    cd ..
done

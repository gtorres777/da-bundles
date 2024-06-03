#!/bin/bash

set -e

shopt -s extglob

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

    # Check if the target is configured in the databricks.yml file
    if ! grep -q "$DATABRICKS_BUNDLE_ENV:" databricks.yml; then
        echo "Target $DATABRICKS_BUNDLE_ENV not configured for $dir. Skipping."
        echo ""
        cd ..
        continue
    fi

    echo "Job: $dir Deployment"
    source ${GITHUB_WORKSPACE}/.github/scripts/set_env.sh $TARGET_ENV $dir
    databricks bundle deploy -t "$DATABRICKS_BUNDLE_ENV"
    echo ""
    cd ..
done

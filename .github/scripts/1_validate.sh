#!/bin/bash

set -e

shopt -s extglob

BRANCH="${GITHUB_REF#refs/heads/}"

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    JOBS="*"
    DATABRICKS_BUNDLE_ENV="PROD"

elif [ "$BRANCH" = "dev" ]; then
    JOBS="*"
    DATABRICKS_BUNDLE_ENV="DEV"
else
    source .github/scripts/check_diff.sh
    JOBS="${CHANGE_DIR_ARRAY[@]}"
    DATABRICKS_BUNDLE_ENV="PROD"
fi


echo "Databricks Bundle Validate"
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

    echo "Job: $dir Validation"
    source ${GITHUB_WORKSPACE}/.github/scripts/set_env.sh $TARGET_ENV $dir
    databricks bundle validate -t "$DATABRICKS_BUNDLE_ENV"
    echo ""
    cd ..
done

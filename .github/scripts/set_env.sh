#!/bin/bash

TARGET_ENV=$1
BUNDLE_PATH=$2
CONFIG_FILE="${BUNDLE_PATH}/config/${TARGET_ENV}.yml"

if [ -f "$CONFIG_FILE" ]; then
  echo "Loading configuration from $CONFIG_FILE"

  export $(grep -v '^#' "$CONFIG_FILE" | xargs)

  echo "Configuration loaded:"
  # echo "NOTEBOOK_PATH=$notebook_path"
  # echo "CLUSTER_NAME=$cluster_name"
  # echo "S3_PATH=$s3_path"
  # echo "DB_URL=$db_url"
  printenv

else
  echo "Configuration file $CONFIG_FILE does not exist"
  exit 1
fi

#!/bin/bash

TARGET_ENV=$1
BUNDLE_PATH=$2

CONFIG_FILE="${GITHUB_WORKSPACE}/${BUNDLE_PATH}/configs/${TARGET_ENV}.yml"

if [ -f "$CONFIG_FILE" ]; then
  echo "Loading configuration from $CONFIG_FILE"

  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^# ]]; then
      continue
    fi

    # Extract variable name and value
    var_name=$(echo "$line" | cut -d '=' -f 1)
    var_value=$(echo "$line" | cut -d '=' -f 2-)

    # Add the BUNDLE_VAR_ prefix to the variable name
    prefixed_var_name="BUNDLE_VAR_${var_name}"

    # Export the variable
    export "$prefixed_var_name"="$var_value"

    echo "$prefixed_var_name=$var_value"
  done < "$CONFIG_FILE"

  echo "Configuration loaded successfully."
else
  echo "Configuration file $CONFIG_FILE does not exist"
fi

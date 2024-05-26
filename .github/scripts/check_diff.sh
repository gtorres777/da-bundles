#!/bin/bash

set -e

git fetch origin

CHANGED_FILES=($(git diff --name-only origin/main..HEAD))

CHANGE_DIR_ARRAY=()

for file in "${CHANGED_FILES[@]}"; do
    root_dir=$(echo $file | cut -f1 -d'/')
    CHANGE_DIR_ARRAY+=("$root_dir")
done

CHANGE_DIR_ARRAY=($(echo "${CHANGE_DIR_ARRAY[@]}" | tr ' ' '\n' | grep -vE '^(README.md)$' | sort -u | tr '\n' ' '))

export CHANGE_DIR_ARRAY

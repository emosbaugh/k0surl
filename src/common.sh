#!/bin/bash

set -euo pipefail

function log() {
    echo "$@"
}

function kustomize_insert_resource() {
    local kustomization_file="$1"
    local resource_file="$2"

    if ! grep -q "resources[ \"]*:" "$kustomization_file"; then
        echo "resources:" >> "$kustomization_file"
    fi

    sed -i "/resources:.*/a - $resource_file" "$kustomization_file"
}

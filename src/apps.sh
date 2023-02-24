#!/bin/bash

set -euo pipefail

function build_apps() {
    "$KUSTOMIZE_BIN" build "$KUSTOMIZE_DIR"/apps/ > apps.yaml
}

function apply_apps() {
    "$KUBECTL_BIN" apply -f apps.yaml
}

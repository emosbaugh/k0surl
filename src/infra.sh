#!/bin/bash

set -euo pipefail

function build_infra() {
    "$KUSTOMIZE_BIN" build "$KUSTOMIZE_DIR"/infrastructure/ > infrastructure.yaml
}

function apply_infra() {
    "$KUBECTL_BIN" apply -f infrastructure.yaml
}

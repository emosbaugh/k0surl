#!/bin/bash

set -euo pipefail

function build_infra() {
    "$KUSTOMIZE_BIN" build "$KUSTOMIZE_DIR"/infrastructure/ > infrastructure.yaml
}

function apply_infra() {
    "$KUBECTL_BIN" apply -f infrastructure.yaml
}

function wait_for_infra() {
    while ! "$KUBECTL_BIN" get sc "local" 2>/dev/null ; do
        log "...waiting for local storage class"
        sleep 10
    done
}

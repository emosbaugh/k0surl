#!/bin/bash

set -euo pipefail

function build_infra() {
    log "building infra config"
    "$KUSTOMIZE_BIN" build "$KUSTOMIZE_DIR"/infrastructure/ > infrastructure.yaml
}

function apply_infra() {
    log "applying infra config"
    "$KUBECTL_BIN" apply -f infrastructure.yaml
}

function wait_for_infra() {
    while ! "$KUBECTL_BIN" get sc "local" 2>/dev/null ; do
        log "...waiting for local storage class"
        sleep 10
    done
}

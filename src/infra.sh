#!/bin/bash

set -euo pipefail

function build_infra() {
    log "building infra config"
    if [ ! -d infrastructure ]; then
        cp -r "$KUSTOMIZE_DIR"/infrastructure infrastructure
    fi
}

function render_infra() {
    local build_dir="$1"
    log "rendering infra config"
    "$KUSTOMIZE_BIN" build "$build_dir"/infrastructure/ > infrastructure.yaml
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

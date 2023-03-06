#!/bin/bash

set -euo pipefail

function build_apps() {
    log "building app config"
    if [ ! -d apps ]; then
        cp -r "$KUSTOMIZE_DIR"/apps apps
    fi
}

function render_apps() {
    local build_dir="$1"
    log "rendering app config"
    "$KUSTOMIZE_BIN" build "$build_dir"/apps/ > apps.yaml
}

function apply_apps() {
    log "applying app config"
    "$KUBECTL_BIN" apply -f apps.yaml
}

function wait_for_apps() {
    wait_for_admin_console
}

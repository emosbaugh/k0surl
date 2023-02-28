#!/bin/bash

set -euo pipefail

function build_apps() {
    log "building app config"
    "$KUSTOMIZE_BIN" build "$KUSTOMIZE_DIR"/apps/ > apps.yaml
}

function apply_apps() {
    log "applying app config"
    "$KUBECTL_BIN" apply -f apps.yaml
}

function wait_for_apps() {
    wait_for_admin_console
}

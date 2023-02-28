#!/bin/bash

set -euo pipefail

FLUX_VERSION=${FLUX_VERSION:-0.40.1}
FLUX_BIN=${FLUX_BIN:-}

function install_flux() {
    if [ -n "$FLUX_BIN" ]; then
        log "using flux from $FLUX_BIN"
        return
    fi
    rm -f flux
    curl -fsSL https://raw.githubusercontent.com/fluxcd/flux2/v"$FLUX_VERSION"/install/flux.sh | FLUX_VERSION="$FLUX_VERSION" bash -s "$(pwd)" 1>/dev/null
    FLUX_BIN="$(pwd)/flux"
    log "flux installed to $FLUX_BIN"
}

function apply_flux() {
    log "installing flux2 operator"
    "$FLUX_BIN" install
}

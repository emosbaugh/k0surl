#!/bin/bash

set -euo pipefail

FLUX_VERSION=${FLUX_VERSION:-v0.40.0}
FLUX_BIN=${FLUX_BIN:-}

function install_flux() {
    if [ -n "$FLUX_BIN" ]; then
        log "using flux from $FLUX_BIN"
        return
    fi
    rm -f flux
    curl -s https://raw.githubusercontent.com/fluxcd/flux2/"$FLUX_VERSION"/install/flux.sh | bash -s "$(pwd)"
    FLUX_BIN="$(pwd)/flux"
    log "flux installed to $FLUX_BIN"
}

function apply_flux() {
    log "installing flux2 operator"
    "$FLUX_BIN" install
}

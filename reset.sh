#!/bin/bash

set -euo pipefail

# arguments

DEBUG=${DEBUG:-false}
RENDER_DIR=${RENDER_DIR:-./build/render}
BIN_DIR=${BIN_DIR:-./bin}
CONFIG_DIR=${CONFIG_DIR:-}

source src/common.sh

function reset() {
    if [ ! -f "$CONFIG_DIR"/cluster.yaml ]; then
        bail "no cluster config found, skipping reset"
    fi

    pushd "$BIN_DIR" >/dev/null
    install_k0sctl
    popd >/dev/null

    pushd "$RENDER_DIR" >/dev/null
    render_k0sctl
    reset_k0sctl
    popd >/dev/null
}

reset "$@"

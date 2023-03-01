#!/bin/bash

set -euo pipefail

# arguments

DEBUG=${DEBUG:-false}
BUILD_DIR=${BUILD_DIR:-./build/config}
RENDER_DIR=${RENDER_DIR:-./build/render}
BIN_DIR=${BIN_DIR:-./bin}
CONFIG_DIR=${CONFIG_DIR:-}
HOSTS_PATCH_FILE=${HOSTS_PATCH_FILE:-}

source src/common.sh

function reset() {
    if [ -n "$CONFIG_DIR" ]; then
        BUILD_DIR="$CONFIG_DIR"
    fi

    pushd "$RENDER_DIR" >/dev/null
    render_k0sctl
    popd >/dev/null

    if [ ! -f "$RENDER_DIR"/cluster.yaml ]; then
        bail "no cluster config found, skipping reset"
    fi

    pushd "$BIN_DIR" >/dev/null
    install_k0sctl
    popd >/dev/null

    pushd "$RENDER_DIR" >/dev/null
    reset_k0sctl
    popd >/dev/null
}

reset "$@"

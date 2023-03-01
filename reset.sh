#!/bin/bash

set -euo pipefail

# arguments

DEBUG=${DEBUG:-false}
BUILD_DIR=${BUILD_DIR:-./build}
BIN_DIR=${BIN_DIR:-./bin}

source src/common.sh

function reset() {
    if [ ! -f "$BUILD_DIR"/cluster.yaml ]; then
        bail "no cluster config found, skipping reset"
    fi
    "$BIN_DIR"/k0sctl reset -c "$BUILD_DIR"/cluster.yaml
}

reset "$@"

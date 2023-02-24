#!/bin/bash

set -euo pipefail

DEBUG=${DEBUG:-false}

BUILD_DIR=${BUILD_DIR:-./build}
BIN_DIR=${BIN_DIR:-./bin}

source src/common.sh

function reset() {
    if [ ! -f "$BUILD_DIR"/k0s-cluster.yaml ]; then
        bail "no cluster config found, skipping reset"
    fi
    "$BIN_DIR"/k0sctl reset -c "$BUILD_DIR"/k0s-cluster.yaml
}

reset "$@"

#!/bin/bash

set -euo pipefail

# arguments

DEBUG=${DEBUG:-false}
BIN_DIR=${BIN_DIR:-./bin}
CONFIG_DIR=${CONFIG_DIR:-./build}

source src/common.sh

function reset() {
    if [ ! -f "$CONFIG_DIR"/cluster.yaml ]; then
        bail "no cluster config found, skipping reset"
    fi
    "$BIN_DIR"/k0sctl reset -c "$CONFIG_DIR"/cluster.yaml
}

reset "$@"

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
source src/binutils.sh
source src/kubectl.sh
source src/kustomize.sh
source src/k0sctl.sh
source src/flux.sh
source src/infra.sh
source src/apps.sh
source src/admin-console.sh
source src/phase.sh

KUSTOMIZE_DIR="$PWD/kustomize"

function main() {
    if [ -n "$CONFIG_DIR" ]; then
        BUILD_DIR="$CONFIG_DIR"
    fi

    if [ -n "$HOSTS_PATCH_FILE" ]; then
        # realpath requires "brew install coreutils" on macOS
        HOSTS_PATCH_FILE="$(realpath "$HOSTS_PATCH_FILE")"
    fi
    maybe_prompt_localhost

    phase_install
    phase_build

    log "default config output to $(realpath "$BUILD_DIR")"
}

main "$@"

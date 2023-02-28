#!/bin/bash

set -euo pipefail

DEBUG=${DEBUG:-false}

CWD="$(pwd)"

BUILD_DIR=${BUILD_DIR:-./build}
BIN_DIR=${BIN_DIR:-./bin}
KUSTOMIZE_DIR="$CWD/kustomize"
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

function main() {
    if [ -n "$CONFIG_DIR" ]; then
        log "using config from $CONFIG_DIR"
        BUILD_DIR="$CONFIG_DIR"
    else
        if [ -n "$HOSTS_PATCH_FILE" ]; then
            # realpath requires "brew install coreutils" on macOS
            HOSTS_PATCH_FILE="$(realpath "$HOSTS_PATCH_FILE")"
        fi
        maybe_prompt_localhost
    fi

    phase_install
    if [ -z "$CONFIG_DIR" ]; then
        phase_build
    fi
    phase_apply

    admin_console_outro
    admin_console_port_forward
}

main "$@"

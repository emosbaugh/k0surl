#!/bin/bash

set -euo pipefail

DEBUG=${DEBUG:-false}

BUILD_DIR=${BUILD_DIR:-./build}
BIN_DIR=${BIN_DIR:-./bin}
KUSTOMIZE_DIR="$PWD/kustomize"

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
    HOSTS_PATCH_FILE="$(hosts_patch_file_realpath)"
    maybe_prompt_localhost

    phase_install
    phase_build

    log "Default config output to $(realpath "$BUILD_DIR")"
}

main "$@"

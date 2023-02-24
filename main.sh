#!/bin/bash

set -euo pipefail

DEBUG=${DEBUG:-false}

CWD="$(pwd)"

BUILD_DIR=${BUILD_DIR:-./build}
BIN_DIR=${BIN_DIR:-./bin}
KUSTOMIZE_DIR="$CWD/kustomize"

HOSTS_PATCH_FILE=${HOSTS_PATCH_FILE:-}

source src/common.sh
source src/kubectl.sh
source src/kustomize.sh
source src/k0sctl.sh
source src/flux.sh
source src/infra.sh
source src/apps.sh
source src/admin-console.sh

function init_build_dir() {
    mkdir -p "$build_dir"
    chmod -R 755 "$build_dir"
}

function init_bin_dir() {
    mkdir -p "$bin_dir"
    chmod -R 755 "$bin_dir"
}

function maybe_prompt_localhost() {
    if [ -n "$HOSTS_PATCH_FILE" ]; then
        HOSTS_PATCH_FILE="$(realpath "$HOSTS_PATCH_FILE")"
        log "using hosts patch $HOSTS_PATCH_FILE"
    else
        printf "using localhost, continue? "
        if ! confirmN ; then
            bail "refusing to use localhost"
        fi
    fi
}

function main() {
    local build_dir="${BUILD_DIR:-./build}"
    local bin_dir="${BIN_DIR:-./bin}"

    init_build_dir
    init_bin_dir

    maybe_prompt_localhost

    pushd "$bin_dir" >/dev/null
    install_kubectl
    install_kustomize
    install_k0sctl
    install_flux
    popd >/dev/null

    pushd "$build_dir" >/dev/null
    build_k0sctl
    apply_k0sctl
    export_kubeconfig_k0sctl
    popd >/dev/null

    pushd "$build_dir" >/dev/null
    apply_flux
    build_infra
    build_apps

    apply_infra
    wait_for_infra

    apply_apps
    popd >/dev/null

    # pushd "$build_dir" >/dev/null
    # build_rook_ceph
    # apply_rook_ceph
    # popd >/dev/null

    wait_for_admin_console
    outro
    port_forward
}

main "$@"

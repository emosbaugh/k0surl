#!/bin/bash

set -euo pipefail

DEBUG=${DEBUG:-false}

CWD="$(pwd)"

BUILD_DIR=${BUILD_DIR:-./build}
INSTALL_DIR=${INSTALL_DIR:-./install}

source src/common.sh
source src/kubectl.sh
source src/kustomize.sh
source src/k0sctl.sh
source src/rook.sh

function init_build_dir() {
    mkdir -p "$build_dir"
    chmod -R 755 "$build_dir"
}

function init_install_dir() {
    mkdir -p "$install_dir"
    chmod -R 755 "$install_dir"
}

function main() {
    local build_dir=, install_dir=
    build_dir="$(realpath "$BUILD_DIR")"
    install_dir="$(realpath "$INSTALL_DIR")"

    init_build_dir
    init_install_dir

    pushd "$install_dir" >/dev/null
    install_kubectl
    install_kustomize
    install_k0sctl
    popd >/dev/null

    pushd "$build_dir" >/dev/null
    build_k0sctl
    apply_k0sctl
    export_kubeconfig_k0sctl
    popd >/dev/null

    pushd "$build_dir" >/dev/null
    build_rook_ceph
    apply_rook_ceph
    popd >/dev/null
}

main "$@"

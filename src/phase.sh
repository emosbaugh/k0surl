#!/bin/bash

set -euo pipefail

function init_build_dir() {
    mkdir -p "$build_dir"
    chmod -R 755 "$build_dir"
}

function init_bin_dir() {
    mkdir -p "$bin_dir"
    chmod -R 755 "$bin_dir"
}

function phase_install() {
    local bin_dir="${BIN_DIR:-./bin}"
    init_bin_dir
    detect_os_arch

    pushd "$bin_dir" >/dev/null
    install_kubectl
    install_kustomize
    install_k0sctl
    install_flux
    popd >/dev/null
}

function phase_build() {
    local build_dir="${BUILD_DIR:-./build}"
    init_build_dir

    pushd "$build_dir" >/dev/null
    build_k0sctl
    build_infra
    build_apps
    popd >/dev/null
}

function phase_apply() {
    local build_dir="${BUILD_DIR:-./build}"
    init_build_dir

    pushd "$build_dir" >/dev/null
    apply_k0sctl
    export_kubeconfig_k0sctl
    apply_flux
    apply_infra
    wait_for_infra
    apply_apps
    wait_for_apps
    popd >/dev/null
}

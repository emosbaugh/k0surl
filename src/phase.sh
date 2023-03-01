#!/bin/bash

set -euo pipefail

function init_bin_dir() {
    mkdir -p "$BIN_DIR"
    chmod -R 755 "$BIN_DIR"
}

function phase_install() {
    init_bin_dir
    detect_os_arch

    pushd "$BIN_DIR" >/dev/null
    install_kubectl
    install_kustomize
    install_k0sctl
    install_flux
    popd >/dev/null
}

function init_build_dir() {
    mkdir -p "$BUILD_DIR"
    chmod -R 755 "$BUILD_DIR"
}

function build_base() {
    rm -rf base
    cp -r "$KUSTOMIZE_DIR"/base base
}

function phase_build() {
    init_build_dir

    pushd "$BUILD_DIR" >/dev/null
    build_base
    build_k0sctl
    build_infra
    build_apps
    popd >/dev/null
}

function init_render_dir() {
    mkdir -p "$RENDER_DIR"
    chmod -R 755 "$RENDER_DIR"
}

function phase_render() {
    init_render_dir

    pushd "$RENDER_DIR" >/dev/null
    render_k0sctl
    render_infra
    render_apps
    popd >/dev/null
}

function phase_apply() {
    init_render_dir

    pushd "$RENDER_DIR" >/dev/null
    apply_k0sctl
    export_kubeconfig_k0sctl
    apply_flux
    apply_infra
    wait_for_infra
    apply_apps
    wait_for_apps
    popd >/dev/null
}

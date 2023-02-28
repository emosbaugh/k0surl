#!/bin/bash

set -euo pipefail

K0SCTL_VERSION=${K0SCTL_VERSION:-v0.15.0}
K0SCTL_BIN=${K0SCTL_BIN:-}

function install_k0sctl() {
    if [ -n "$K0SCTL_BIN" ]; then
        log "using k0sctl from $K0SCTL_BIN"
        return
    fi
    rm -f k0sctl
    # shellcheck disable=SC2153
    local arch="$ARCH"
    if [ "$arch" = "amd64" ]; then
        arch="x64"
    fi
    curl -fsSL -o k0sctl https://github.com/k0sproject/k0sctl/releases/download/"$K0SCTL_VERSION"/k0sctl-"$OS"-"$arch"
    chmod +x k0sctl
    K0SCTL_BIN="$(pwd)/k0sctl"
    log "k0sctl installed to $K0SCTL_BIN"
}

function build_k0sctl() {
    log "building k0s config"
    local tmp_dir=
    tmp_dir="$(mktemp -d)"
    cp -r "$KUSTOMIZE_DIR"/k0sctl/* "$tmp_dir"
    if [ -n "$HOSTS_PATCH_FILE" ]; then
        cp "$HOSTS_PATCH_FILE" "$tmp_dir"/hosts.patch.yaml
    fi
    "$KUSTOMIZE_BIN" build "$tmp_dir" > k0s-cluster.yaml
    rm -rf "$tmp_dir"
}

function apply_k0sctl() {
    log "applying k0s cluster"
    "$K0SCTL_BIN" apply -c k0s-cluster.yaml --debug="$DEBUG"
}

function hosts_patch_file_realpath() {
    if [ -n "$HOSTS_PATCH_FILE" ]; then
        # realpath requires "brew install coreutils" on macOS
        realpath "$HOSTS_PATCH_FILE"
    fi
}

function maybe_prompt_localhost() {
    if [ -n "$HOSTS_PATCH_FILE" ]; then
        log "using hosts patch $HOSTS_PATCH_FILE"
    else
        printf "using localhost, continue? "
        if ! confirmN ; then
            bail "refusing to use localhost"
        fi
    fi
}

function export_kubeconfig_k0sctl() {
    "$K0SCTL_BIN" kubeconfig -c k0s-cluster.yaml > kubeconfig.yaml
    export KUBECONFIG
    KUBECONFIG="$(pwd)/kubeconfig.yaml"
}

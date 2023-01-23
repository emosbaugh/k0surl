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
    curl -fsSL -o k0sctl https://github.com/k0sproject/k0sctl/releases/download/"$K0SCTL_VERSION"/k0sctl-linux-x64
    chmod +x k0sctl
    K0SCTL_BIN="$(pwd)/k0sctl"
    log "k0sctl installed to $K0SCTL_BIN"
}

function build_k0sctl() {
    log "building k0s cluster"
    "$KUSTOMIZE_BIN" build "$CWD"/kustomize/k0sctl/ > k0s-cluster.yaml
}

function apply_k0sctl() {
    log "applying k0s cluster"
    "$K0SCTL_BIN" apply -c k0s-cluster.yaml --debug="$DEBUG"
}

function export_kubeconfig_k0sctl() {
    "$K0SCTL_BIN" kubeconfig -c k0s-cluster.yaml > kubeconfig.yaml
    export KUBECONFIG
    KUBECONFIG="$(pwd)/kubeconfig.yaml"
}

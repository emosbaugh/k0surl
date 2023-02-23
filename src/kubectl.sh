#!/bin/bash

set -euo pipefail

KUBECTL_VERSION=${KUBECTL_VERSION:-v1.26.1}
KUBECTL_BIN=${KUBECTL_BIN:-}

function install_kubectl() {
    if [ -n "$KUBECTL_BIN" ]; then
        log "using kubectl from $KUBECTL_BIN"
        return
    fi
    rm -f kustomize
    curl -fsSLO https://dl.k8s.io/release/"$KUBECTL_VERSION"/bin/linux/amd64/kubectl
    chmod +x kubectl
    KUBECTL_BIN="$(pwd)/kubectl"
    log "kubectl installed to $KUBECTL_BIN"
}

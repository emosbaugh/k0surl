#!/bin/bash

set -euo pipefail

KUSTOMIZE_BIN=${KUSTOMIZE_BIN:-}

function install_kustomize() {
    if [ -n "$KUSTOMIZE_BIN" ]; then
        log "using kustomize from $KUSTOMIZE_BIN"
        return
    fi
    rm -f kustomize
    curl -fsSL "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash >/dev/null
    KUSTOMIZE_BIN="$(pwd)/kustomize"
    log "kustomize installed to $KUSTOMIZE_BIN"
}

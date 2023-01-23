#!/bin/bash

set -euo pipefail

function build_rook_ceph() {
    log "building rook-ceph cluster resources"
    "$KUSTOMIZE_BIN" build "$CWD"/kustomize/rook-ceph/ > rook-ceph.yaml
}

function apply_rook_ceph() {
    log "applying rook-ceph cluster resources"
    k0s kubectl apply -f rook-ceph.yaml
}

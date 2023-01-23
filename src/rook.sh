#!/bin/bash

set -euo pipefail

function build_rook_ceph() {
    log "building rook-ceph cluster resources"
    "$KUSTOMIZE_BIN" build "$CWD"/kustomize/rook-ceph/ > rook-ceph.yaml
}

function apply_rook_ceph() {
    log "applying rook-ceph cluster resources"
    "$KUBECTL_BIN" apply -f rook-ceph.yaml
}

function rook_wait_for_crds() {
    log "waiting for rook-ceph CRDs to be ready"
    while ! rook_crds_available >/dev/null 2>&1 ; do
        sleep 1
    done
}

function rook_crds_available() {
    "$KUBECTL_BIN" wait --for=condition=established --timeout=60s crd/cephclusters.ceph.rook.io
    "$KUBECTL_BIN" wait --for=condition=established --timeout=60s crd/cephblockpools.ceph.rook.io
    "$KUBECTL_BIN" wait --for=condition=established --timeout=60s crd/cephobjectstores.ceph.rook.io
    "$KUBECTL_BIN" wait --for=condition=established --timeout=60s crd/cephobjectstoreusers.ceph.rook.io
}

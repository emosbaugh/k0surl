#!/bin/bash

set -euo pipefail

ADMIN_CONSOLE_PORT=${ADMIN_CONSOLE_PORT:-8800}
ADMIN_CONSOLE_PASSWORD=${ADMIN_CONSOLE_PASSWORD:-admin}

function wait_for_admin_console() {
    while ! "$KUBECTL_BIN" rollout status deploy/kotsadm --timeout=10s 2>/dev/null ; do
        log "...waiting for admin-console"
        sleep 2
    done
}

function outro() {
    printf "\n%bYou can access the Admin Console at http://localhost:%s with password \"%s\" %b\n\n" \
        "$GREEN" "$ADMIN_CONSOLE_PORT" "$ADMIN_CONSOLE_PASSWORD" "$NC"
}

function port_forward() {
    ( set -x; "$KUBECTL_BIN" port-forward service/admin-console "$ADMIN_CONSOLE_PORT:80" )
}

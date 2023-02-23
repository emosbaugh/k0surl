#!/bin/bash

set -euo pipefail

ADMIN_CONSOLE_PORT=${ADMIN_CONSOLE_PORT:-8800}
ADMIN_CONSOLE_PASSWORD=${ADMIN_CONSOLE_PASSWORD:-admin}

function outro() {
    printf "\n%bYou can access the Admin Console at http://localhost:%s with password \"%s\" %b\n\n" \
        "$GREEN" "$ADMIN_CONSOLE_PORT" "$ADMIN_CONSOLE_PASSWORD" "$NC"
}

function port_forward() {
    ( set -x; kubectl port-forward service/admin-console "$ADMIN_CONSOLE_PORT:80" )
}

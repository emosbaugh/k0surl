#!/bin/bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color

function log() {
    echo "$@"
}

function bail() {
    log "$@"
    exit 1
}

function prompts_can_prompt() {
    # Need the TTY to accept input and stdout to display
    # Prompts when running the script through the terminal but not as a subshell
    if [ -c /dev/tty ]; then
        return 0
    fi
    return 1
}

function prompt() {
    if ! prompts_can_prompt ; then
        bail "cannot prompt, shell is not interactive"
    fi

    set +e
    if [ -z ${TEST_PROMPT_RESULT+x} ]; then
        read -r PROMPT_RESULT < /dev/tty
    else
        PROMPT_RESULT="$TEST_PROMPT_RESULT"
    fi
    set -e
}

function confirmN() {
    printf "(y/N) "
    if [ "$ASSUME_YES" = "1" ]; then
        echo "Y"
        return 0
    fi
    if ! prompts_can_prompt ; then
        echo "N"
        log "automatically declining prompt, shell is not interactive"
        return 1
    fi
    prompt
    if [ "$PROMPT_RESULT" = "y" ] || [ "$PROMPT_RESULT" = "Y" ]; then
        return 0
    fi
    return 1
}

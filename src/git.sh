#!/bin/bash

set -euo pipefail

function git_confirm_and_commit() {
    # requires git as a host dependency
    local did_git_init=0
    if ! git_has_init ; then
        git_init
        did_git_init=1
    fi
    git_add
    if [ "$did_git_init" = "0" ] && git_has_diff ; then
        git_diff
        printf "apply changes? "
        confirmN
    fi
    if [ "$did_git_init" = "1" ]; then
        git_commit "initial commit"
    else  
        git_commit "update"
    fi
}

function git_has_init() {
    [ -d .git ]
}

function git_init() {
    if [ ! -d .git ]; then
        git init
    fi
}

function git_add() {
    git add .
}

function git_commit() {
    git commit -m "$1"
}

function git_has_diff() {
    if ! git diff-index --quiet HEAD -- ; then
        return 0
    else
        return 1
    fi
}

function git_diff() {
    git --no-pager diff --cached
}

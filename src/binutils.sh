#!/bin/bash

set -euo pipefail

OS=${OS:-linux}
ARCH=${ARCH:-amd64}

function detect_os_arch() {
    case "$(uname -s)" in
        Darwin)
            OS=darwin
            ;;
        Linux)
            OS=linux
            ;;
        *)
            bail "unsupported OS: $(uname -s)"
            ;;
    esac

    case "$(uname -m)" in
        x86_64)
            ARCH=amd64
            ;;
        arm64)
            ARCH=arm64
            ;;
        *)
            bail "unsupported architecture: $(uname -m)"
            ;;
    esac
}

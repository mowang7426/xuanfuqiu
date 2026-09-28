#!/usr/bin/env bash
set -euo pipefail

THEOS_DIR="${THEOS_DIR:-$HOME/theos}"

if ! command -v git >/dev/null 2>&1; then
    printf '%s\n' "git is required. Install it with your system package manager." >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    printf '%s\n' "curl is required. Install it with your system package manager." >&2
    exit 1
fi

if [ -d "$THEOS_DIR" ]; then
    printf 'Theos directory already exists: %s\n' "$THEOS_DIR"
else
    printf 'Installing roothide Theos into %s\n' "$THEOS_DIR"
    export THEOS="$THEOS_DIR"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/roothide/theos/master/bin/install-theos)"
fi

printf '\nExport this path before building:\n'
printf 'export THEOS=%q\n' "$THEOS_DIR"
printf '\nBuild commands:\n'
printf 'make clean package THEOS_PACKAGE_SCHEME=rootless\n'
printf 'make clean package THEOS_PACKAGE_SCHEME=roothide\n'

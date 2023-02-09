#!/usr/bin/env bash
set -euo pipefail

readonly MACOS_PATH='/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

function main {
    local linux_path
    linux_path="$(command -v openscad || :)"

    if test -n "${linux_path}"; then
        echo "${linux_path}"
        return 0
    fi

    if test -x "${MACOS_PATH}"; then
        echo "${MACOS_PATH}"
        return 0
    fi

    >&2 echo '---(X) Error: Failed to find OpenSCAD binary path: Check OpenSCAD is installed'
    exit 1
}


main "$@"

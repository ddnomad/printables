#!/usr/bin/env bash
set -euo pipefail


function get_openscad_bin_path {
    local linux_path
    linux_path="$(command -v openscad)"

    if test -n "${linux_path}"; then
        echo "${linux_path}"
        return 0
    fi

    local macos_path
    macos_path='/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

    if test -x "${macos_path}"; then
        echo "${macos_path}"
        return 0
    fi

    >&2 echo '---(X) Error: Failed to find OpenSCAD binary path: Check OpenSCAD is installed'
    exit 1
}


function main {
    if test "$#" -ne 2; then
        >&2 echo 'Usage: '"$(basename "$0")"' TARGET_FILE_PATH OUTPUT_PATH'
        exit 1
    fi

    local target_file_path
    target_file_path="$1"

    local output_path
    output_path="$2"

    if ! test -f "${target_file_path}"; then
        >&2 echo "---(X) Error: Target file path does not exist or is not a regular file: ${target_file_path}"
        exit 1
    fi

    local openscad_bin_path
    openscad_bin_path="$(get_openscad_bin_path)"

    "${openscad_bin_path}" \
        -o "${output_path}" \
        --autocenter \
        --imgsize 1028,512 \
        --viewall \
        "${target_file_path}"
}


main "$@"

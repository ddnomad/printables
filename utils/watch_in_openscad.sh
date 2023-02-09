#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(dirname "$0")"
readonly SCRIPT_PATH

OPENSCAD_BIN_PATH="$("${SCRIPT_PATH}"/get_openscad_bin_path.sh)"
readonly OPENSCAD_BIN_PATH


function main {
    if test "$#" -ne 1; then
        >&2 echo 'Usage: '"$(basename "$0")"' TARGET_FILE_PATH'
        exit 1
    fi

    local target_file_path
    target_file_path="$1"

    if ! test -f "${target_file_path}"; then
        >&2 echo "---(X) Error: Target file path does not exist or is not a regular file: ${target_file_path}"
        exit 1
    fi

    "${OPENSCAD_BIN_PATH}" "${target_file_path}"
}


main "$@"

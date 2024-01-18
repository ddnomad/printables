#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(dirname "$0")"
readonly SCRIPT_PATH

OPENSCAD_BIN_PATH="$("${SCRIPT_PATH}"/get_openscad_bin_path.sh)"
readonly OPENSCAD_BIN_PATH


function main {
    if test "$#" -ne 2; then
        >&2 echo 'Usage: '"$(basename "$0")"' TARGET_FILE_PATH OUTPUT_FILE_PATH'
        exit 1
    fi

    local target_file_path
    target_file_path="$1"

    local output_file_path
    output_file_path="$2"

    if [[ "${output_file_path}" != *.stl ]]; then
        >&2 echo "---(X) Error: Output file path must have .stl extension: ${output_file_path}"
        exit 1
    fi

    if ! test -f "${target_file_path}"; then
        >&2 echo "---(X) Error: Target file path does not exist or is not a regular file: ${target_file_path}"
        exit 1
    fi

    >&2 echo "---(i) INFO: Generating model STL (this may take a while)"

    local start_ts
    start_ts="$(date +%s)"

    "${OPENSCAD_BIN_PATH}" -o "${output_file_path}" "${target_file_path}"

    local end_ts
    end_ts="$(date +%s)"

    local elapsed_seconds
    elapsed_seconds=$((end_ts - start_ts))

    >&2 echo "---(+) DONE: Generated model STL in ${elapsed_seconds} seconds: ${output_file_path}"
}


main "$@"

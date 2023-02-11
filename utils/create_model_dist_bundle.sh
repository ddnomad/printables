#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(dirname "$0")"
readonly SCRIPT_PATH


function main {
    if test "$#" -ne 2; then
        >&2 echo 'Usage: '"$(basename "$0")"' MODEL_DIR_PATH OUTPUT_FILE_PATH'
        exit 1
    fi

    local model_dir_path
    model_dir_path="$1"

    local output_file_path
    output_file_path="$2"

    if  ! [[ "${output_file_path}" == *.zip ]]; then
        >&2 echo '---(!) WARNING: Output file path does not have .zip extension'
    fi

    local output_dir_path
    output_dir_path="$(dirname "${output_file_path}")"

    if ! test -d "${output_dir_path}"; then
        >&2 echo "---(X) ERROR: Output file path parent directory does not exist: ${output_dir_path}"
        exit 1
    fi
    
    >&2 echo "---(i) INFO: Creating model distribution bundle for model in ${model_dir_path}"

    local temp_dir_path
    temp_dir_path="$(mktemp -d)"

    >&2 echo "---(i) INFO: Using temporary directory: ${temp_dir_path}"

    local archive_root_dir_name
    archive_root_dir_name="${temp_dir_path}/$(basename "${output_file_path%.*}")"

    mkdir -p "${archive_root_dir_name}"

    cp "${model_dir_path}"/build/* "${archive_root_dir_name}"

    cp "${model_dir_path}"/CHANGELOG.md "${archive_root_dir_name}"
    cp "${model_dir_path}"/README.md "${archive_root_dir_name}"
    cp "${SCRIPT_PATH}"/../LICENSE "${archive_root_dir_name}"

    local abs_output_file_path
    abs_output_file_path="$(realpath "${output_file_path}")"

    cd "${temp_dir_path}" && zip -r "${abs_output_file_path}" ./* && cd - &>/dev/null
    >&2 echo "---(+) DONE: Created distribution bundle: ${output_file_path}"

    rm -r "${temp_dir_path}"
}


main "$@"

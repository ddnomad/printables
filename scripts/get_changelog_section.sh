#!/usr/bin/env bash
set -euo pipefail

function main {
    if test "$#" -ne 2; then
        >&2 echo 'Usage: '"$(basename "$0")"' CHANGELOG_FILE_PATH SECTION_NAME'
        exit 1
    fi

    local changelog_file_path
    changelog_file_path="$1"

    local section_name
    section_name="$2"

    if ! test -f "${changelog_file_path}"; then
        >&2 echo "---(X) Error: Changelog file path does not exist or is not a regular file: ${changelog_file_path}"
        exit 1
    fi

    local in_target_section
    in_target_section=false

    local line
    local prev_line

    while read -r line; do
        if [[ "${line}" == -* ]]; then
            if test "${prev_line}" == "${section_name}"; then
                in_target_section=true
                echo "${prev_line}"
            else
                in_target_section=false
            fi
        elif test "${in_target_section}" == true; then
            echo "${prev_line}"
        fi

        prev_line="${line}"
    done < "${changelog_file_path}"

    if test "${in_target_section}" = true; then
        echo "${prev_line}"
    fi
}


main "$@"

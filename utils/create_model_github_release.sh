#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(dirname "$0")"
readonly SCRIPT_PATH

function main {
    if test "$#" -ne 3; then
        >&2 echo 'Usage: '"$(basename "$0")"' MODEL_PATH MODEL_NAME RELEASE_VERSION'
        exit 1
    fi

    local model_path
    model_path="$1"

    local model_name
    model_name="$2"

    local release_version
    release_version="$3"

    local release_changelog
    release_changelog="$("${SCRIPT_PATH}/get_changelog_section.sh" "${model_path}/CHANGELOG.md" "${release_version}")"

    echo "Release model path: ${model_path}"
    echo "Release model name: ${model_name}"
    echo "Release version: ${release_version}"
    echo -e "Release changelog:\n\n${release_changelog}"
}


main "$@"

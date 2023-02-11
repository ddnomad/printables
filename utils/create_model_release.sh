#!/usr/bin/env bash
set -euo pipefail

readonly PRETTY_MODEL_NAME_RE='^ *MODEL_NAME *= *"\(.*\)"; *$'
readonly VALID_MODEL_NAME_RE="^[0-9A-Za-z]+([-_][0-9A-Za-z]+)*$"
readonly VALID_RELEASE_VERSION_RE="v[0-9]+(\.[0-9]+){2}"

SCRIPT_PATH="$(dirname "$0")"
readonly SCRIPT_PATH


function main {
    if ! command -v gh &> /dev/null; then
        >&2 echo '---(X) Error: This script requires gh (GitHub CLI) to be installed and in PATH'
        exit 1
    fi

    if test "$#" -ne 4; then
        >&2 echo 'Usage: '"$(basename "$0")"' MODEL_PATH MODEL_NAME RELEASE_VERSION RELEASE_BRANCH'
        exit 1
    fi

    local model_path
    model_path="$1"

    if ! test -d "${model_path}"; then
        >&2 echo "---(X) Error: Model path does not exist or is not a directory: ${model_path}"
        exit 1
    fi

    local model_name
    model_name="$2"

    if test "${#model_name}" -lt 3 || ! [[ "${model_name}" =~ ${VALID_MODEL_NAME_RE} ]]; then
        >&2 echo "---(X) Error: Model name is not valid: ${model_name}"
        exit 1
    fi

    local release_version
    release_version="$3"

    if ! [[ "${release_version}" =~ ${VALID_RELEASE_VERSION_RE} ]]; then
        >&2 echo "---(X) Error: Model release version is not valid: ${release_version}"
        exit 1
    fi

    local release_branch
    release_branch="$4"

    local release_changelog
    release_changelog="$(
        "${SCRIPT_PATH}/get_changelog_section.sh" "${model_path}/CHANGELOG.md" "${release_version}" | \
        tail -n +4
    )"

    if test -z "${release_changelog}"; then
        >&2 echo "---(X) Error: Failed to find a changelog entry for a given release version: ${release_version}"
        >&2 echo '              NOTE: The entry might be an empty Markdown section which is still invalid'
        exit 1
    fi

    local release_tag
    release_tag="${model_name}/${release_version}"

    local release_title
    release_title="$(sed -n 's@'"${PRETTY_MODEL_NAME_RE}"'@\1@p' "${model_path}/main.scad" | sed 's/\\//') ${release_version}"

    echo "---(i) INFO: Creating release ${release_tag}"

    # shellcheck disable=SC2046
    echo "${release_changelog}" | gh release create \
        --notes-file - \
        --target "${release_branch}" \
        --title "${release_title}" \
        "${release_tag}" \
        $(find "${model_path}/build" -type f | tr '\n' ' ')
}


main "$@"

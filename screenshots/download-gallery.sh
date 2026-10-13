#!/usr/bin/env bash
set -euo pipefail

repository="arhalok/Stride-Chat"
remote_archive="/workspaces/Stride-Chat/screenshots/exports/element-x-android-english-gallery.zip"
codespace="${1:-}"
download_dir="${2:-$HOME/Downloads}"
archive="$download_dir/element-x-android-english-gallery.zip"
gallery_dir="$download_dir/element-x-android-english-gallery"

for command in gh unzip; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done

if [[ -z "$codespace" ]]; then
    mapfile -t codespaces < <(gh codespace list --repo "$repository" --json name,state --jq '.[] | [.name, .state] | @tsv')
    available_codespaces=()
    for entry in "${codespaces[@]}"; do
        IFS=$'\t' read -r name state <<< "$entry"
        if [[ "$state" == "Available" ]]; then
            available_codespaces+=("$name")
        fi
    done

    if [[ "${#available_codespaces[@]}" -eq 1 ]]; then
        codespace="${available_codespaces[0]}"
    elif [[ "${#available_codespaces[@]}" -gt 1 ]]; then
        printf 'More than one Codespace is available. Run: %s <codespace-name>\n' "$0" >&2
        printf 'Available Codespaces: %s\n' "${available_codespaces[*]}" >&2
        exit 1
    elif [[ "${#codespaces[@]}" -eq 1 ]]; then
        IFS=$'\t' read -r codespace _ <<< "${codespaces[0]}"
    else
        printf 'No Codespace found for %s. Start one or pass its name as an argument.\n' "$repository" >&2
        exit 1
    fi
fi

mkdir -p "$download_dir"
partial_archive="$archive.partial.$$"
trap 'rm -f "$partial_archive"' EXIT

printf 'Downloading gallery from Codespace %s...\n' "$codespace"
gh codespace ssh -c "$codespace" -- cat "$remote_archive" > "$partial_archive"
unzip -tqq "$partial_archive"
mv -f -- "$partial_archive" "$archive"
unzip -oq "$archive" -d "$download_dir"
trap - EXIT

printf 'ZIP verified: %s\nGallery: %s/index.html\n' "$archive" "$gallery_dir"
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$gallery_dir/index.html" >/dev/null 2>&1 &
fi
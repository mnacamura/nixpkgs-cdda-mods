#!/usr/bin/env bash

set -euo pipefail

remote_name=github
remote_branch=master
commit_msg="Automatic overlay update"

create_commit=yes
deploy_update=no

msg() {
    echo -e "\e[32m[MSG]\e[0m $*" >&2
}

warn() {
    echo -e "\e[33m[WRN]\e[0m $*" >&2
}

err() {
    echo -e "\e[31m[ERR]\e[0m $*" >&2
    exit 1
}

show_usage() {
    echo "Usage: $0 [--no-commit] [--deploy] [-h|--help]" >&2
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --no-commit)
            create_commit=no
            shift
            ;;
        --deploy)
            deploy_update=yes
            shift
            ;;
        -h|--help)
            show_usage
            exit 1
            ;;
        *)
            shift
            ;;
    esac
done

if [ "$create_commit" = no -a "$deploy_update" = yes ]; then
    err "Are you sure to deploy update without creating any commit?"
fi

msg "Updating jenkins builds..."
if ! ./update-jenkins.scm; then
    err "...failed"
fi
msg "...done"

msg "Updating mods..."
if ! ./update-mods.scm; then
    err "...failed"
fi
msg "...done"

if [ "$(git diff ./generated .sha256-cache.json | wc -l)" -eq 0 ]; then
    msg "No updates found"
    exit 0
else
    msg "Updates found"
fi

if [ "$create_commit" = yes ]; then
    msg "Staging the updates..."
    if ! git add ./generated .sha256-cache.json; then
        err "...failed"
    fi
    msg "...done"

    msg "Creating a git commit..."
    if ! git commit -m "$commit_msg"; then
        err "...failed"
    fi
    msg "...done"
fi


if [ "$deploy_update" = yes ]; then
    msg "Pushing the git commit..."
    if ! git push "$remote_name" "$remote_branch"; then
        err "...failed"
    fi
    msg "...done"
fi

#!/usr/bin/env bash

echo -n "Updating jenkins builds..." >&2
if ! ./update-jenkins.scm; then
    echo "...failed" >&2
    exit 1
fi
echo "...done" >&2

echo -n "Updating mods..." >&2
if ! ./update-mods.scm; then
    echo "...failed" >&2
    exit 1
fi
echo "...done" >&2

if [ "$(git diff ./generated | wc -l)" -eq 0 ]; then
    echo "No updates found" >&2
    exit 0
else
    echo "Updates found" >&2
fi

echo -n "Staging the updates..." >&2
if ! git add ./generated .sha256-cache.json; then
    echo "...failed" >&2
    exit 1
fi
echo "...done"

echo -n "Creating a git commit..." >&2
if ! git commit -m "Update overlay"; then
    echo "...failed" >&2
    exit 1
fi
echo "...done"

echo -n "Pushing the git commit..." >&2
if ! git push github master; then
    echo "...failed" >&2
    exit 1
fi
echo "...done"

#!/usr/bin/env bash

set -euo pipefail

src="${1:-.}"
parent="${2:-.}"

if [[ ! -e "${src}" ]]; then
	echo "Source '${src}' does not exist" >&2
	exit 1
elif [[ ! -d "${src}" ]]; then
	echo "Source '${src}' exists but is not a directory" >&2
	exit 1
fi

timestamp="$(date +%F_%H%M%S)"
dest="${parent}/${src}_backup_${timestamp}"

mkdir -p -- "$dest"

cp -a -- "${src}"/. "${dest}"/

echo "Backed up '${src}' into '${dest}'"

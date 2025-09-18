#!/usr/bin/env bash
# decompress.sh - repeatedly decompress a file until it becomes human-readable text

set -euo pipefail

file=${1:?usage: $(basename "$0") FILE}

[[ -f "$file" ]] || { echo "no file: $file" >&2; exit 1; }

out="$file"

while true; do
    # Detect file type
    type=$(file -b --mime-type "$out")

    case "$type" in
        application/gzip)
            echo "[*] gunzip: $out"
            gunzip -f "$out"
            out="${out%.gz}"
            ;;
        application/x-bzip2)
            echo "[*] bunzip2: $out"
            bunzip2 -f "$out"
            out="${out%.bz2}"
            ;;
        application/x-xz)
            echo "[*] unxz: $out"
            unxz -f "$out"
            out="${out%.xz}"
            ;;
        application/x-tar)
            echo "[*] tar extract: $out"
            newdir="${out%.tar}_contents"
            mkdir -p "$newdir"
            tar -xf "$out" -C "$newdir"
            out=$(find "$newdir" -type f | head -n1)
            ;;
        text/plain|application/json|application/xml)
            echo "[+] Reached readable text: $out"
            head -n 20 "$out"
            break
            ;;
        *)
            echo "[?] Unknown type ($type), stopping."
            file "$out"
            break
            ;;
    esac
done

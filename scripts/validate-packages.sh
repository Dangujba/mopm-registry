#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
shopt -s nullglob
for pkg in packages/*; do
  [[ -d "$pkg" ]] || { echo "Not a package directory: $pkg" >&2; exit 1; }
  name=${pkg#packages/}
  [[ "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "Invalid package name: $name" >&2; exit 1; }
  [[ -f "$pkg/__init__.mojo" ]] || { echo "Package missing __init__.mojo: $pkg" >&2; exit 1; }
  if find "$pkg" -type l -print -quit | grep -q .; then echo "Symlink in package: $pkg" >&2; exit 1; fi
  while IFS= read -r -d '' file; do
    case "$file" in *.mojo|*.md|*.txt|*.toml|*/LICENSE|*/NOTICE) ;; *) echo "Unsupported package asset: $file" >&2; exit 1;; esac
    [[ $(wc -c < "$file") -le 1048576 ]] || { echo "Package file over 1 MiB: $file" >&2; exit 1; }
  done < <(find "$pkg" -type f -print0)
done
echo "Package source format: OK"

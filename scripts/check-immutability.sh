#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
base="${1:-}"
[[ -n "$base" ]] || { echo "Usage: check-immutability.sh BASE_GIT_REF" >&2; exit 2; }
old="$(mktemp)"
trap 'rm -f "$old"' EXIT
git show "${base}:index.tsv" | grep -vE '^[[:space:]]*(#|$)' > "$old" || true
while IFS= read -r row || [[ -n "$row" ]]; do
  grep -Fxq -- "$row" index.tsv || { echo "Registry version was removed or modified: $row" >&2; exit 1; }
done < "$old"
echo "Existing package versions remain immutable"

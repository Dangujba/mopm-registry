#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
base="${1:?Usage: check-archive-immutability.sh BASE_SHA}"
old="$(mktemp)"
trap 'rm -f "$old"' EXIT
git show "$base:index.json" > "$old"
jq -e --slurpfile previous "$old" '
  . as $current |
  [ $previous[0].packages | to_entries[] |
    .key as $n | .value.versions | to_entries[] |
    .key as $v | .value == $current.packages[$n].versions[$v]
  ] | all
' index.json >/dev/null || { echo "Published .mopm versions are immutable" >&2; exit 1; }
echo "Published package versions preserved"

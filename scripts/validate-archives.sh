#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
fail() { echo "MoPM registry: $*" >&2; exit 1; }
command -v jq >/dev/null || fail "jq missing"
command -v unzip >/dev/null || fail "unzip missing"
jq -e '.schema==2 and (.packages|type=="object")' index.json >/dev/null || fail "index.json has invalid schema"
while IFS=$'\t' read -r name version path digest size deps; do
  [[ "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ && "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "invalid package identity"
  [[ "$path" == "packages/$name/$version.mopm" && "$digest" =~ ^[a-f0-9]{64}$ ]] || fail "invalid archive path/hash"
  [[ -f "$path" ]] || fail "missing artifact $path"
  [[ "$(wc -c < "$path" | tr -d ' ')" -eq "$size" ]] || fail "size mismatch for $path"
  [[ "$size" -le 10485760 ]] || fail "archive too large"
  [[ "$(sha256sum "$path" | cut -d' ' -f1)" == "$digest" ]] || fail "SHA-256 mismatch for $path"
  unzip -tq "$path" >/dev/null || fail "corrupt archive"
  while IFS= read -r entry; do
    [[ "$entry" != /* && "$entry" != *'..'* && "$entry" != *'\\'* ]] || fail "unsafe archive path"
    [[ "$entry" == mopm.json || "$entry" == src/* ]] || fail "unexpected archive path"
  done < <(unzip -Z1 "$path")
  unzip -Z1 "$path" | grep -Fxq src/__init__.mojo || fail "missing __init__.mojo"
  metadata="$(unzip -p "$path" mopm.json)"
  jq -e --arg n "$name" --arg v "$version" --argjson d "$deps" '.format=="mopm-v1" and .name==$n and .version==$v and .dependencies==$d' <<< "$metadata" >/dev/null || fail "metadata mismatch"
done < <(jq -r '.packages|to_entries[]|.key as $n|.value.versions|to_entries[]|[$n,.key,.value.file,.value.sha256,(.value.size|tostring),(.value.dependencies|tojson)]|@tsv' index.json)
jq -e '.packages as $p | [ .packages | to_entries[] | .value.versions | to_entries[] | .value.dependencies | to_entries[] | .key as $n | .value as $v | ($p[$n].versions[$v]!=null) ] | all' index.json >/dev/null || fail "unknown dependency"
echo "Central .mopm archives: PASS"

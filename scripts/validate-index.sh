#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[[ -f index.tsv ]] || { echo "Missing index.tsv" >&2; exit 1; }
OWNER_REPO="${MOPM_REGISTRY_REPO:-Dangujba/mopm-registry}"
declare -A known=()
declare -A required=()
count=0
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  [[ "${line//[^|]/}" == '|||||' ]] || { echo "Invalid field count: $line" >&2; exit 1; }
  IFS='|' read -r name version repo sha subdir deps <<< "$line"
  [[ "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "Bad name: $name" >&2; exit 1; }
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Bad version: $version" >&2; exit 1; }
  [[ "$repo" == "$OWNER_REPO" ]] || { echo "Only centralized sources accepted: $repo" >&2; exit 1; }
  [[ "$sha" =~ ^[a-fA-F0-9]{40}$ ]] || { echo "Bad commit SHA: $sha" >&2; exit 1; }
  [[ "$subdir" == "packages/$name" ]] || { echo "Subdirectory must be packages/$name" >&2; exit 1; }
  key="$name@$version"
  [[ ! -v known["$key"] ]] || { echo "Duplicate package version: $key" >&2; exit 1; }
  known["$key"]=1
  git cat-file -e "${sha}^{commit}" || { echo "Missing source commit: $sha" >&2; exit 1; }
  git cat-file -e "${sha}:${subdir}/__init__.mojo" || { echo "Source commit lacks $subdir/__init__.mojo" >&2; exit 1; }
  if [[ "$deps" != '-' ]]; then
    [[ -n "$deps" ]] || { echo "Empty dependency list: $key" >&2; exit 1; }
    IFS=',' read -r -a items <<< "$deps"
    for dep in "${items[@]}"; do
      [[ "$dep" =~ ^[A-Za-z_][A-Za-z0-9_]*@[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid dependency '$dep' in $key" >&2; exit 1; }
      required["$dep"]=1
    done
  fi
  ((count+=1))
done < index.tsv
for dep in "${!required[@]}"; do
  [[ -v known["$dep"] ]] || { echo "Unknown dependency: $dep" >&2; exit 1; }
done
printf 'Registry index: OK (%s versions)\n' "$count"

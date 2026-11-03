#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[[ $# -eq 3 ]] || { echo "Usage: scripts/register-package.sh NAME VERSION DEPENDENCIES_OR_-" >&2; exit 2; }
name="$1"; version="$2"; deps="$3"
[[ "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "Invalid name" >&2; exit 1; }
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid version" >&2; exit 1; }
[[ "$deps" == '-' || "$deps" =~ ^[A-Za-z_][A-Za-z0-9_]*@[0-9]+\.[0-9]+\.[0-9]+(,[A-Za-z_][A-Za-z0-9_]*@[0-9]+\.[0-9]+\.[0-9]+)*$ ]] || { echo "Bad dependencies" >&2; exit 1; }
[[ -f "packages/$name/__init__.mojo" ]] || { echo "Missing package: packages/$name/__init__.mojo" >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "Commit the package source first. Working tree must be clean." >&2; exit 1; }
sha="$(git rev-parse --verify HEAD)"
git cat-file -e "${sha}:packages/$name/__init__.mojo" || { echo "Missing tracked package in HEAD" >&2; exit 1; }
if grep -E "^${name}\|${version//./\\.}\|" index.tsv >/dev/null; then
  echo "Already registered: $name@$version (immutable version)" >&2; exit 1
fi
printf '%s|%s|Dangujba/mopm-registry|%s|packages/%s|%s\n' "$name" "$version" "$sha" "$name" "$deps" >> index.tsv
if ! bash scripts/validate-index.sh; then
  sed -i '$d' index.tsv
  exit 1
fi
printf 'Registered %s@%s at commit %s\nCommit index.tsv in a NEW commit, then push.\n' "$name" "$version" "$sha"

#!/usr/bin/env bash
set -euo pipefail
src="$(cd "$(dirname "$0")/.." && pwd)"
testroot="$(mktemp -d)"
trap 'rm -rf "$testroot"' EXIT
cp -a "$src/." "$testroot/"
cd "$testroot"
rm -rf .git
# Start with an empty index so tests do not depend on live commit SHAs.
sed -i '/^[^#[:space:]]/d' index.tsv
git init -q -b main
git config user.name 'MoPM CI Test'
git config user.email 'ci@example.invalid'
git add .
git commit -qm 'Commit sample source'
bash scripts/validate-index.sh
bash scripts/validate-packages.sh
bash scripts/register-package.sh greeter 1.0.0 -
[[ $(grep -Ec '^greeter\|1\.0\.0\|' index.tsv) -eq 1 ]]
if bash scripts/register-package.sh greeter 1.0.0 - >/dev/null 2>&1; then
  echo 'Duplicate registration incorrectly allowed' >&2; exit 1
fi
bash scripts/validate-index.sh
git add index.tsv
git commit -qm 'Register sample version'
bash scripts/check-immutability.sh HEAD~1
sed -i '/^greeter|/d' index.tsv
if bash scripts/check-immutability.sh HEAD >/dev/null 2>&1; then
  echo 'Immutable row removal incorrectly allowed' >&2; exit 1
fi
git checkout -- index.tsv
sed -i -E 's/\|[0-9a-f]{40}\|/|0000000000000000000000000000000000000000|/' index.tsv
if bash scripts/validate-index.sh >/dev/null 2>&1; then
  echo 'Invalid source SHA incorrectly allowed' >&2; exit 1
fi
echo 'Central registry tests: PASS'

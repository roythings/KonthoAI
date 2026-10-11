#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Source of truth is root index.html; deployment output is dist/index.html
if [ -f index.html ] && [ ! -f dist/index.html ]; then
  mkdir -p dist
  cp index.html dist/index.html
fi
test -f dist/index.html
echo "KonthoAI startup OK: dist/index.html present ($(wc -c < dist/index.html) bytes)"

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
: "${PORT:=3000}"
/usr/bin/time -p bash -c 'echo "KonthoAI start: PORT=$PORT PROJECT_DIR=$PWD"'
/usr/bin/time -p test -f dist/index.html
/usr/bin/time -p bash -c 'echo "No dependencies to install (static site)"'
/usr/bin/time -p bash -c 'echo "Build check: dist/index.html present, no build needed"'
/usr/bin/time -p mkdir -p "${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p bash -c 'OUT="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}/deployment-output.json"; printf "{\"project\":\"%s\",\"directory\":\"%s\"}" "$PWD" "$PWD/dist" > "$OUT"; echo "Wrote $OUT:"; cat "$OUT"; echo'
/usr/bin/time -p bash -c 'echo "Serving $PWD/dist on 0.0.0.0:$PORT"'
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$PWD/dist" --bind 0.0.0.0

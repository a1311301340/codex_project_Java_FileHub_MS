#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/set-local-env.sh"

NPM_REGISTRY="${FILEHUB_NPM_REGISTRY:-https://registry.npmmirror.com}"

pushd "$PROJECT_ROOT/frontend" >/dev/null
npm install --registry "$NPM_REGISTRY"
npm run build
popd >/dev/null

rm -rf "$PROJECT_ROOT/dist/frontend"
mkdir -p "$PROJECT_ROOT/dist/frontend"
cp -r "$PROJECT_ROOT/frontend/dist/." "$PROJECT_ROOT/dist/frontend"

echo "[ok] frontend dist generated at dist/frontend"

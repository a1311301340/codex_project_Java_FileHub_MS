#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
NPM_REGISTRY="${FILEHUB_NPM_REGISTRY:-https://registry.npmmirror.com}"

"$SCRIPT_DIR/build-backend.sh"
"$SCRIPT_DIR/build-frontend.sh"

export NPM_CONFIG_CACHE="$PROJECT_ROOT/.cache/npm"

pushd "$PROJECT_ROOT/desktop" >/dev/null
npm install --registry "$NPM_REGISTRY"
npm run package:linux
popd >/dev/null

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/set-local-env.sh"

if [ -x "$HOME/.jdks/ms-17.0.16/bin/java" ]; then
  export JAVA_HOME="$HOME/.jdks/ms-17.0.16"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

DIST_BACKEND="$PROJECT_ROOT/dist/backend"
mkdir -p "$DIST_BACKEND"

if command -v mvn >/dev/null 2>&1; then
  mvn -f "$PROJECT_ROOT/backend/pom.xml" clean package -DskipTests -Dmaven.repo.local="$PROJECT_ROOT/.cache/maven-repo"
elif command -v docker >/dev/null 2>&1; then
  docker run --rm -v "$PROJECT_ROOT:/workspace" -w /workspace maven:3.9.9-eclipse-temurin-17 mvn -f backend/pom.xml clean package -DskipTests -Dmaven.repo.local=/workspace/.cache/maven-repo
else
  echo "Neither mvn nor docker is available." >&2
  exit 1
fi

cp "$PROJECT_ROOT/backend/target/filehub-backend-0.1.0.jar" "$DIST_BACKEND/filehub-backend.jar"

cat > "$DIST_BACKEND/run-backend-linux.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
if [ -x "$ROOT/runtime/bin/java" ]; then
  "$ROOT/runtime/bin/java" -jar "$ROOT/filehub-backend.jar"
else
  java -jar "$ROOT/filehub-backend.jar"
fi
EOF
chmod +x "$DIST_BACKEND/run-backend-linux.sh"

cat > "$DIST_BACKEND/run-backend-win.bat" <<'EOF'
@echo off
setlocal
set ROOT=%~dp0
if exist "%ROOT%runtime\\bin\\java.exe" (
  "%ROOT%runtime\\bin\\java.exe" -jar "%ROOT%filehub-backend.jar"
) else (
  java -jar "%ROOT%filehub-backend.jar"
)
EOF

if command -v jlink >/dev/null 2>&1; then
  rm -rf "$DIST_BACKEND/runtime"
  jlink --add-modules java.base,java.desktop,java.logging,java.naming,java.net.http,java.security.jgss,java.sql,jdk.crypto.ec,jdk.unsupported \
        --output "$DIST_BACKEND/runtime" \
        --compress=2 \
        --strip-debug \
        --no-header-files \
        --no-man-pages
fi

echo "[ok] backend dist generated at dist/backend"

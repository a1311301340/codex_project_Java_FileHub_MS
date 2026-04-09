#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAVEN_HOME="$PROJECT_ROOT/.cache/maven-home"
MAVEN_REPO="$PROJECT_ROOT/.cache/maven-repo"
NPM_CACHE="$PROJECT_ROOT/.cache/npm"

mkdir -p "$MAVEN_HOME" "$MAVEN_REPO" "$NPM_CACHE"

export MAVEN_USER_HOME="$MAVEN_HOME"
export MAVEN_OPTS="-Dmaven.repo.local=$MAVEN_REPO"
export NPM_CONFIG_CACHE="$NPM_CACHE"

echo "[env] MAVEN_USER_HOME=$MAVEN_USER_HOME"
echo "[env] MAVEN_OPTS=$MAVEN_OPTS"
echo "[env] NPM_CONFIG_CACHE=$NPM_CONFIG_CACHE"

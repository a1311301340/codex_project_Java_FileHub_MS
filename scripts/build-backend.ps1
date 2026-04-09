$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\set-local-env.ps1"

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$DistBackend = Join-Path $ProjectRoot 'dist\backend'
$MavenRepo = ((Join-Path $ProjectRoot '.cache\maven-repo') -replace '\\', '/')

function Use-Java17 {
    $candidate = Join-Path $env:USERPROFILE '.jdks\ms-17.0.16'
    if (Test-Path (Join-Path $candidate 'bin\java.exe')) {
        $env:JAVA_HOME = $candidate
        $env:Path = "$candidate\bin;$env:Path"
        Write-Host "[env] JAVA_HOME=$env:JAVA_HOME"
        return
    }

    if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
        throw "Java runtime not found. Please install JDK 17 or provide JAVA_HOME."
    }
}

Use-Java17
New-Item -ItemType Directory -Force -Path $DistBackend | Out-Null

Push-Location $ProjectRoot
try {
    if (Get-Command mvn -ErrorAction SilentlyContinue) {
        & mvn -f backend\pom.xml clean package -DskipTests "-Dmaven.repo.local=$MavenRepo"
        if ($LASTEXITCODE -ne 0) {
            throw "Maven build failed with exit code $LASTEXITCODE"
        }
    } elseif (Get-Command docker -ErrorAction SilentlyContinue) {
        & docker run --rm -v "${ProjectRoot}:/workspace" -w /workspace maven:3.9.9-eclipse-temurin-17 mvn -f backend/pom.xml clean package -DskipTests -Dmaven.repo.local=/workspace/.cache/maven-repo
        if ($LASTEXITCODE -ne 0) {
            throw "Dockerized Maven build failed with exit code $LASTEXITCODE"
        }
    } else {
        throw "Neither mvn nor docker is available."
    }

    $JarPath = Join-Path $ProjectRoot 'backend\target\filehub-backend-0.1.0.jar'
    if (-not (Test-Path $JarPath)) {
        throw "Build succeeded but jar was not found: $JarPath"
    }

    Copy-Item -Force -LiteralPath $JarPath -Destination (Join-Path $DistBackend 'filehub-backend.jar')

    $winScript = @(
        '@echo off',
        'setlocal',
        'set ROOT=%~dp0',
        'if exist "%ROOT%runtime\\bin\\java.exe" (',
        '  "%ROOT%runtime\\bin\\java.exe" -jar "%ROOT%filehub-backend.jar"',
        ') else (',
        '  java -jar "%ROOT%filehub-backend.jar"',
        ')'
    ) -join "`r`n"
    Set-Content -LiteralPath (Join-Path $DistBackend 'run-backend-win.bat') -Value $winScript -Encoding ASCII

    $linuxScript = @(
        '#!/usr/bin/env bash',
        'set -euo pipefail',
        'ROOT="$(cd "$(dirname "$0")" && pwd)"',
        'if [ -x "$ROOT/runtime/bin/java" ]; then',
        '  "$ROOT/runtime/bin/java" -jar "$ROOT/filehub-backend.jar"',
        'else',
        '  java -jar "$ROOT/filehub-backend.jar"',
        'fi'
    ) -join "`n"
    Set-Content -LiteralPath (Join-Path $DistBackend 'run-backend-linux.sh') -Value $linuxScript -Encoding UTF8

    if (Get-Command jlink -ErrorAction SilentlyContinue) {
        $RuntimeDir = Join-Path $DistBackend 'runtime'
        if (Test-Path $RuntimeDir) {
            Remove-Item -Recurse -Force -LiteralPath $RuntimeDir
        }

        $modules = 'java.base,java.desktop,java.logging,java.naming,java.net.http,java.security.jgss,java.sql,jdk.crypto.ec,jdk.unsupported'
        & jlink --add-modules $modules --output $RuntimeDir --compress=2 --strip-debug --no-header-files --no-man-pages
        if ($LASTEXITCODE -ne 0) {
            throw "jlink runtime build failed with exit code $LASTEXITCODE"
        }
    }

    Write-Host '[ok] backend dist generated at dist/backend'
}
finally {
    Pop-Location
}

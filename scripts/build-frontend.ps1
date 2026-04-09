$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\set-local-env.ps1"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$FrontendRoot = Join-Path $ProjectRoot 'frontend'
$DistFrontend = Join-Path $ProjectRoot 'dist\frontend'
$NpmRegistry = if ([string]::IsNullOrWhiteSpace($env:FILEHUB_NPM_REGISTRY)) { 'https://registry.npmmirror.com' } else { $env:FILEHUB_NPM_REGISTRY }

Push-Location $FrontendRoot
try {
    npm install --registry $NpmRegistry
    if ($LASTEXITCODE -ne 0) {
        throw "npm install failed with exit code $LASTEXITCODE"
    }

    npm run build
    if ($LASTEXITCODE -ne 0) {
        throw "npm run build failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

if (Test-Path $DistFrontend) {
    Remove-Item -Recurse -Force -LiteralPath $DistFrontend
}
New-Item -ItemType Directory -Force -Path $DistFrontend | Out-Null
Copy-Item -Recurse -Force -LiteralPath (Join-Path $FrontendRoot 'dist\*') -Destination $DistFrontend

Write-Host '[ok] frontend dist generated at dist/frontend'

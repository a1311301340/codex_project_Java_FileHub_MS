$ErrorActionPreference = 'Stop'
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$NpmRegistry = if ([string]::IsNullOrWhiteSpace($env:FILEHUB_NPM_REGISTRY)) { 'https://registry.npmmirror.com' } else { $env:FILEHUB_NPM_REGISTRY }

& "$PSScriptRoot\build-backend.ps1"
& "$PSScriptRoot\build-frontend.ps1"

$DesktopRoot = Join-Path $ProjectRoot 'desktop'
Push-Location $DesktopRoot
try {
    $env:NPM_CONFIG_CACHE = "$ProjectRoot\.cache\npm"
    npm install --registry $NpmRegistry
    if ($LASTEXITCODE -ne 0) {
        throw "desktop npm install failed with exit code $LASTEXITCODE"
    }

    npm run package:win
    if ($LASTEXITCODE -ne 0) {
        throw "windows package build failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

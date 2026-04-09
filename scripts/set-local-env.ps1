$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$MavenHome = Join-Path $ProjectRoot '.cache\maven-home'
$MavenRepo = Join-Path $ProjectRoot '.cache\maven-repo'
$NpmCache = Join-Path $ProjectRoot '.cache\npm'

New-Item -ItemType Directory -Force -Path $MavenHome, $MavenRepo, $NpmCache | Out-Null

$MavenRepoForward = ($MavenRepo -replace '\\', '/')

$env:MAVEN_USER_HOME = $MavenHome
$env:MAVEN_OPTS = "-Dmaven.repo.local=$MavenRepoForward"
$env:NPM_CONFIG_CACHE = $NpmCache

Write-Host "[env] MAVEN_USER_HOME=$env:MAVEN_USER_HOME"
Write-Host "[env] MAVEN_OPTS=$env:MAVEN_OPTS"
Write-Host "[env] NPM_CONFIG_CACHE=$env:NPM_CONFIG_CACHE"

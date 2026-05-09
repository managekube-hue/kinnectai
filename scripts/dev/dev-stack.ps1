param(
    [string]$ProjectRoot = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}

$dockerBin = "C:\Users\$env:USERNAME\AppData\Local\Programs\DockerDesktop\resources\bin"
if (Test-Path (Join-Path $dockerBin "docker.exe")) {
    $env:PATH = "$dockerBin;$env:PATH"
}

Set-Location $ProjectRoot

docker context use desktop-linux | Out-Null
docker compose up -d --build

# Apply database schema orchestration on every boot.
& (Join-Path $PSScriptRoot "..\bootstrap\migrate-postgres.ps1") -ProjectRoot $ProjectRoot
& (Join-Path $PSScriptRoot "..\bootstrap\init-cassandra.ps1") -ProjectRoot $ProjectRoot

docker compose ps
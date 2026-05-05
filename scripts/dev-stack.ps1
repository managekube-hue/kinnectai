param(
    [string]$ProjectRoot = "C:\dev\kinnectai-backend"
)

$ErrorActionPreference = "Stop"

Set-Location $ProjectRoot

docker compose up --build
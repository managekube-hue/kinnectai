param(
    [string]$ProjectRoot = "C:\dev\kinnectai-backend"
)

$ErrorActionPreference = "Stop"

$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$machinePath;$userPath"

Set-Location $ProjectRoot

go run ./cmd/api
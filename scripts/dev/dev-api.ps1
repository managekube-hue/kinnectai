param(
    [string]$ProjectRoot = ""
)

$ErrorActionPreference = "Stop"

$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$machinePath;$userPath"

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}

Set-Location "$ProjectRoot\services\go\feed-service"

go run ./cmd/api
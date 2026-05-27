$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $root

$golangci = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\golangci-lint.exe'
$services = @('gateway', 'identity-service')

foreach ($svc in $services) {
  $svcPath = Join-Path 'services/go' $svc
  $modFile = Join-Path $svcPath 'go.mod'
  if (-not (Test-Path $modFile)) {
    Write-Host "skip $svc (no go.mod)"
    continue
  }

  Write-Host "linting $svc"
  Push-Location $svcPath
  try {
    if (Test-Path $golangci) {
      & $golangci run ./...
    } else {
      go vet ./...
    }
  } finally {
    Pop-Location
  }
}

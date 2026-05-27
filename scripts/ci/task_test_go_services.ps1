$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $root

Remove-Item 'coverage.out' -ErrorAction SilentlyContinue
$coverFiles = @()
$services = @('gateway', 'identity-service')

foreach ($svc in $services) {
  $svcPath = Join-Path 'services/go' $svc
  $modFile = Join-Path $svcPath 'go.mod'
  if (-not (Test-Path $modFile)) {
    Write-Host "skip $svc (no go.mod)"
    continue
  }

  Write-Host "testing $svc"
  Push-Location $svcPath
  try {
    go test ./...
    go test -coverprofile coverage.out ./...
    $coverFiles += (Join-Path (Get-Location) 'coverage.out')
  } finally {
    Pop-Location
  }
}

if ($coverFiles.Count -gt 0) {
  Copy-Item -LiteralPath $coverFiles[-1] -Destination 'coverage.out' -Force
}

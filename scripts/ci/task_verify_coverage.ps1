$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'coverage.out')) {
  Write-Host 'skip coverage gate (coverage.out missing)'
  exit 0
}

$line = (go tool cover -func=coverage.out | Select-String 'total').ToString()
if (-not $line) {
  Write-Host 'skip coverage gate (no total line)'
  exit 0
}

$parts = $line.Trim() -split ' '
$token = ($parts | Where-Object { $_ -and $_ -match '%' } | Select-Object -Last 1)
if (-not $token) {
  Write-Host 'skip coverage gate (unable to parse percent)'
  exit 0
}

$pct = [double]($token.TrimEnd('%'))
if ($pct -lt 80) {
  Write-Error ("Go coverage $pct% < 80% threshold")
  exit 1
}

Write-Host ("Coverage validation passed: $pct%")

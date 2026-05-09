$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$mobileLib = Join-Path $repoRoot 'apps/mobile/lib'

Write-Host 'Running icon/color policy checks...'

$violations = @()

$iconViolations = Select-String -Path "$mobileLib/**/*.dart" -Pattern 'Icons\.' -SimpleMatch
foreach ($v in $iconViolations) {
  if ($v.Path -notmatch 'icon_mapping\.dart') {
    $violations += "Disallowed Material icon at $($v.Path):$($v.LineNumber)"
  }
}

$hexColorViolations = Select-String -Path "$mobileLib/**/*.dart" -Pattern 'Color\(0x[0-9A-Fa-f]{8}\)'
foreach ($v in $hexColorViolations) {
  if ($v.Path -notmatch 'theme/colors\.dart') {
    $violations += "Hardcoded color literal at $($v.Path):$($v.LineNumber)"
  }
}

$modelDynamicViolations = Select-String -Path "$mobileLib/models/**/*.dart" -Pattern '\bdynamic\b'
foreach ($v in $modelDynamicViolations) {
  $violations += "Dynamic type in model at $($v.Path):$($v.LineNumber)"
}

if ($violations.Count -gt 0) {
  Write-Host 'Policy violations found:' -ForegroundColor Red
  $violations | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host 'Icon/color/model policy checks passed.' -ForegroundColor Green

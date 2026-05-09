Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $repoRoot

$errors = [System.Collections.Generic.List[string]]::new()

function Assert-Exists {
  param(
    [string]$Path,
    [string]$Message
  )

  if (-not (Test-Path $Path)) {
    $errors.Add($Message)
  }
}

function Assert-CodeFilesPresent {
  param(
    [string]$Directory,
    [string[]]$Extensions,
    [string]$Message
  )

  $files = Get-ChildItem -Path $Directory -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -in $Extensions }

  if (($files | Measure-Object).Count -eq 0) {
    $errors.Add($Message)
  }
}

# Required top-level structure
@(
  'apps/mobile',
  'apps/web',
  'services/gateway',
  'services/go',
  'services/python',
  'packages/shared-contracts',
  'packages/design-system',
  'packages/auth-sdk',
  'packages/telemetry',
  'packages/consent-engine',
  'infra/terraform',
  'infra/kubernetes',
  'infra/helm',
  'infra/monitoring',
  'infra/kafka',
  'infra/postgres',
  'infra/neo4j',
  'infra/redis',
  'migrations/postgres',
  'migrations/neo4j',
  'migrations/cassandra',
  'docs/architecture',
  'docs/product',
  'docs/compliance',
  'docs/api',
  'docs/runbooks',
  'docs/adr',
  'docs/diagrams',
  'scripts/bootstrap',
  'scripts/dev',
  'scripts/ci',
  'scripts/release',
  'scripts/data',
  'tests/integration',
  'tests/e2e',
  'tests/load',
  'tests/contracts'
) | ForEach-Object {
  Assert-Exists -Path $_ -Message "Missing required path: $_"
}

# Ensure services root only has allowed group folders
$allowedServiceRoots = @('gateway', 'go', 'python')
$serviceRootDirs = Get-ChildItem -Path 'services' -Directory | Select-Object -ExpandProperty Name
$unexpectedServiceRoots = $serviceRootDirs | Where-Object { $_ -notin $allowedServiceRoots }
foreach ($dir in $unexpectedServiceRoots) {
  $errors.Add("Unexpected service root directory (must be under services/go or services/python): services/$dir")
}

# Ensure all expected services exist
$expectedGoServices = @(
  'feed-service',
  'graph-service',
  'media-service',
  'rooms-service',
  'memorybox-service',
  'payment-service',
  'notification-service',
  'identity-service'
)

$expectedPythonServices = @(
  'kernel-service',
  'discovery-service',
  'behavioral-service',
  'dna-ingest-service',
  'photoplay-service',
  'moderation-service',
  'voiceprint-service'
)

foreach ($svc in $expectedGoServices) {
  $path = "services/go/$svc"
  Assert-Exists -Path $path -Message "Missing Go service folder: $path"
  if (Test-Path $path) {
    Assert-CodeFilesPresent -Directory $path -Extensions @('.go') -Message "Placeholder Go service without .go files: $path"
  }
}

foreach ($svc in $expectedPythonServices) {
  $path = "services/python/$svc"
  Assert-Exists -Path $path -Message "Missing Python service folder: $path"
  if (Test-Path $path) {
    Assert-CodeFilesPresent -Directory $path -Extensions @('.py') -Message "Placeholder Python service without .py files: $path"
  }
}

# Next.js production checks for web app
Assert-Exists -Path 'apps/web/app/layout.tsx' -Message 'apps/web is missing Next layout.tsx'
Assert-Exists -Path 'apps/web/app/page.tsx' -Message 'apps/web is missing root page.tsx'
Assert-Exists -Path 'apps/web/next.config.mjs' -Message 'apps/web is missing next.config.mjs'
Assert-Exists -Path 'apps/web/package.json' -Message 'apps/web is missing package.json'

if (Test-Path 'apps/web/package.json') {
  $pkg = Get-Content -Path 'apps/web/package.json' -Raw | ConvertFrom-Json
  if ($pkg.scripts.dev -notmatch 'next dev') {
    $errors.Add('apps/web package.json dev script must use next dev')
  }
  if ($pkg.scripts.build -notmatch 'next build') {
    $errors.Add('apps/web package.json build script must use next build')
  }
}

if ($errors.Count -gt 0) {
  Write-Host 'Monorepo structure verification failed:' -ForegroundColor Red
  foreach ($e in $errors) {
    Write-Host " - $e" -ForegroundColor Red
  }
  exit 1
}

Write-Host 'Monorepo structure verification passed.' -ForegroundColor Green

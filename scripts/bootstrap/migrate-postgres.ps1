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

$container = "postgres"
$migrationsDir = Join-Path $ProjectRoot "migrations\postgres"

if (-not (Test-Path $migrationsDir)) {
    throw "Migrations directory not found: $migrationsDir"
}

Write-Host "[migrate-postgres] Waiting for PostgreSQL readiness..."
for ($i = 0; $i -lt 60; $i++) {
    docker compose exec -T $container pg_isready -U kinnect -d kinnectai *> $null
    if ($LASTEXITCODE -eq 0) {
        break
    }
    Start-Sleep -Seconds 2
}

docker compose exec -T $container pg_isready -U kinnect -d kinnectai *> $null
if ($LASTEXITCODE -ne 0) {
    throw "PostgreSQL is not ready after waiting."
}

# Migration ledger for repeatable, one-time application per file.
$ledgerSql = @"
CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
"@

docker compose exec -T $container psql -U kinnect -d kinnectai -v ON_ERROR_STOP=1 -c $ledgerSql | Out-Null

$migrationFiles = Get-ChildItem -Path $migrationsDir -Filter "*.sql" -File | Sort-Object Name

foreach ($file in $migrationFiles) {
    $version = $file.Name
    $versionEscaped = $version.Replace("'", "''")

    $checkSql = "SELECT 1 FROM schema_migrations WHERE version = '$versionEscaped' LIMIT 1;"
    $alreadyApplied = docker compose exec -T $container psql -U kinnect -d kinnectai -tAc $checkSql

    if (-not [string]::IsNullOrWhiteSpace($alreadyApplied)) {
        Write-Host "[migrate-postgres] Skipping already applied migration: $version"
        continue
    }

    Write-Host "[migrate-postgres] Applying migration: $version"
    $containerPath = "/docker-entrypoint-initdb.d/$version"
    docker compose exec -T $container psql -U kinnect -d kinnectai -v ON_ERROR_STOP=1 -f $containerPath
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to apply migration: $version"
    }

    $insertSql = "INSERT INTO schema_migrations(version) VALUES ('$versionEscaped');"
    docker compose exec -T $container psql -U kinnect -d kinnectai -v ON_ERROR_STOP=1 -c $insertSql | Out-Null
}

Write-Host "[migrate-postgres] Complete."

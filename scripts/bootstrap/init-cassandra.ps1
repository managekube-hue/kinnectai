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

$container = "cassandra"
$cassandraSchema = Join-Path $ProjectRoot "migrations\cassandra\001_initial_schema.cql"

if (-not (Test-Path $cassandraSchema)) {
    throw "Cassandra schema file not found: $cassandraSchema"
}

Write-Host "[init-cassandra] Waiting for Cassandra readiness..."
for ($i = 0; $i -lt 90; $i++) {
    docker compose exec -T $container cqlsh localhost -e "describe keyspaces" *> $null
    if ($LASTEXITCODE -eq 0) {
        break
    }
    Start-Sleep -Seconds 2
}

docker compose exec -T $container cqlsh localhost -e "describe keyspaces" *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Cassandra is not ready after waiting."
}

# The schema uses IF NOT EXISTS statements, so applying on every boot is idempotent.
Write-Host "[init-cassandra] Applying cassandra_schema.cql"

# Convert to Linux path that is valid inside container via bind mount.
$containerSchemaPath = "/schema/001_initial_schema.cql"

docker compose exec -T $container cqlsh localhost -f $containerSchemaPath
if ($LASTEXITCODE -ne 0) {
    throw "Failed applying Cassandra schema: $containerSchemaPath"
}

Write-Host "[init-cassandra] Complete."

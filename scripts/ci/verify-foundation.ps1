param(
    [string]$PostgresHost = "localhost",
    [int]$PostgresPort = 5432,
    [string]$Neo4jHost = "localhost",
    [int]$Neo4jBoltPort = 7687,
    [int]$Neo4jHttpPort = 7474,
    [string]$CassandraHost = "localhost",
    [int]$CassandraPort = 9042,
    [string]$KafkaHost = "localhost",
    [int]$KafkaPort = 9092,
    [string]$RedisHost = "localhost",
    [int]$RedisPort = 6379,
    [string]$ApiBase = "http://localhost:8080"
)

$ErrorActionPreference = "Stop"

function Test-TcpPort {
    param(
        [string]$TargetHost,
        [int]$Port,
        [int]$TimeoutMs = 2000
    )

    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $ar = $client.BeginConnect($TargetHost, $Port, $null, $null)
        $ok = $ar.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
        if (-not $ok) {
            return $false
        }
        $client.EndConnect($ar) | Out-Null
        return $true
    }
    catch {
        return $false
    }
    finally {
        $client.Close()
    }
}

$checks = @(
    @{ Name = "PostgreSQL"; Host = $PostgresHost; Port = $PostgresPort },
    @{ Name = "Neo4j Bolt"; Host = $Neo4jHost; Port = $Neo4jBoltPort },
    @{ Name = "Cassandra"; Host = $CassandraHost; Port = $CassandraPort },
    @{ Name = "Kafka"; Host = $KafkaHost; Port = $KafkaPort },
    @{ Name = "Redis"; Host = $RedisHost; Port = $RedisPort }
)

$failed = @()

Write-Host "Checking core foundation services..."
foreach ($check in $checks) {
    $up = Test-TcpPort -TargetHost $check.Host -Port $check.Port
    if ($up) {
        Write-Host ("[OK]   {0} at {1}:{2}" -f $check.Name, $check.Host, $check.Port)
    }
    else {
        Write-Host ("[FAIL] {0} at {1}:{2}" -f $check.Name, $check.Host, $check.Port)
        $failed += $check.Name
    }
}

# Neo4j HTTP health probe.
try {
    $resp = Invoke-WebRequest -Uri ("http://{0}:{1}" -f $Neo4jHost, $Neo4jHttpPort) -Method Get -TimeoutSec 3
    if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 500) {
        Write-Host ("[OK]   Neo4j HTTP at {0}:{1}" -f $Neo4jHost, $Neo4jHttpPort)
    }
}
catch {
    Write-Host ("[WARN] Neo4j HTTP probe failed at {0}:{1}" -f $Neo4jHost, $Neo4jHttpPort)
}

# API health probe.
try {
    $health = Invoke-RestMethod -Uri ($ApiBase.TrimEnd('/') + "/health") -Method Get -TimeoutSec 3
    if ($health.status -eq "ok") {
        Write-Host ("[OK]   Backend health endpoint at {0}/health" -f $ApiBase.TrimEnd('/'))
    }
    else {
        Write-Host ("[WARN] Backend health endpoint returned unexpected payload")
    }
}
catch {
    Write-Host ("[WARN] Backend health endpoint unreachable at {0}/health" -f $ApiBase.TrimEnd('/'))
}

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host ("Foundation check failed for: {0}" -f ($failed -join ", "))
    exit 1
}

Write-Host ""
Write-Host "Foundation check passed."
exit 0

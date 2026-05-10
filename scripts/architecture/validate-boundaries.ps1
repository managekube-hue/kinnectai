#!/bin/bash
# validate-boundaries.ps1
# ======================
# Architecture boundary enforcement validator
# Prevents cyclic dependencies, domain layer contamination, and transport leakage

param(
    [string]$ServicePath = "services",
    [bool]$Verbose = $false,
    [bool]$FailFast = $true
)

$violations = @()

# Rule 1: Domain layer must not import infrastructure
function Test-DomainLayerPurity {
    param([string]$ServiceDir)
    
    $domainFiles = Get-ChildItem -Path "$ServiceDir/internal/domain" -Recurse -Filter "*.go" -ErrorAction SilentlyContinue
    
    foreach ($file in $domainFiles) {
        $content = Get-Content $file
        if ($content -match "import.*infrastructure" -or $content -match "import.*transport") {
            [PSCustomObject]@{
                severity = "CRITICAL"
                rule = "Domain-Infrastructure-Separation"
                file = $file.FullName
                message = "Domain layer imports infrastructure or transport"
            }
        }
    }
}

# Rule 2: No direct service-to-service imports
function Test-ServiceBoundaries {
    param([string]$ServiceDir)
    
    $files = Get-ChildItem -Path $ServiceDir -Recurse -Filter "*.go" -ErrorAction SilentlyContinue
    $serviceName = Split-Path $ServiceDir -Leaf
    
    foreach ($file in $files) {
        $content = Get-Content $file
        if ($content -match "github\.com/kinnectai/services/[^/]+/((?!$serviceName))" -and -not ($content -match "shared-libs")) {
            [PSCustomObject]@{
                severity = "HIGH"
                rule = "No-Direct-Service-Imports"
                file = $file.FullName
                message = "Service imports another service directly (use API gateway or events)"
            }
        }
    }
}

# Rule 3: Transport layer must not contain business logic
function Test-TransportLayerIsolation {
    param([string]$ServiceDir)
    
    $transportFiles = Get-ChildItem -Path "$ServiceDir/internal/transport" -Recurse -Filter "*.go" -ErrorAction SilentlyContinue
    
    foreach ($file in $transportFiles) {
        $content = Get-Content $file
        # Check for business logic patterns (if/switch statements, complex calculations)
        if ($content -match "business.*logic|core.*algorithm|complex.*calculation" -and -not ($content -match "validation|serialization")) {
            [PSCustomObject]@{
                severity = "MEDIUM"
                rule = "Transport-Logic-Isolation"
                file = $file.FullName
                message = "Transport layer contains business logic (move to domain/application)"
            }
        }
    }
}

# Rule 4: All domain errors must be in errors.go
function Test-ErrorLayering {
    param([string]$ServiceDir)
    
    $nonErrorFiles = Get-ChildItem -Path "$ServiceDir/internal/domain" -Recurse -Filter "*.go" -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "errors.go" }
    
    foreach ($file in $nonErrorFiles) {
        $content = Get-Content $file
        if ($content -match "type.*Error\s+struct" -and $file.Name -ne "errors.go") {
            [PSCustomObject]@{
                severity = "MEDIUM"
                rule = "Error-Centralization"
                file = $file.FullName
                message = "Error type defined outside errors.go (consolidate in errors.go)"
            }
        }
    }
}

# Run all validations
Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║ ARCHITECTURE BOUNDARY VALIDATOR                                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

$serviceCount = 0
$violationCount = 0

$services = Get-ChildItem -Path $ServicePath -Directory -ErrorAction SilentlyContinue

foreach ($service in $services) {
    $serviceCount++
    if ($Verbose) {
        Write-Host "Validating: $($service.Name)" -ForegroundColor Yellow
    }
    
    $domainViolations = Test-DomainLayerPurity $service.FullName
    $boundaryViolations = Test-ServiceBoundaries $service.FullName
    $transportViolations = Test-TransportLayerIsolation $service.FullName
    $errorViolations = Test-ErrorLayering $service.FullName
    
    $serviceViolations = $domainViolations + $boundaryViolations + $transportViolations + $errorViolations
    
    if ($serviceViolations.Count -gt 0) {
        $violationCount += $serviceViolations.Count
        $violations += $serviceViolations
        
        if ($FailFast -and $serviceViolations | Where-Object {$_.severity -eq "CRITICAL"}) {
            Write-Host "STOP: Critical violation found in $($service.Name)" -ForegroundColor Red
            exit 1
        }
    }
}

# Report
if ($violations.Count -eq 0) {
    Write-Host "✅ All $serviceCount services passed architecture boundary validation" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Found $($violations.Count) violations across $serviceCount services" -ForegroundColor Red
    Write-Host ""
    
    $critical = $violations | Where-Object {$_.severity -eq "CRITICAL"}
    $high = $violations | Where-Object {$_.severity -eq "HIGH"}
    $medium = $violations | Where-Object {$_.severity -eq "MEDIUM"}
    
    if ($critical.Count -gt 0) {
        Write-Host "CRITICAL ($($critical.Count)):" -ForegroundColor Red
        $critical | ForEach-Object { Write-Host "  ❌ $($_.rule): $($_.message)" }
    }
    
    if ($high.Count -gt 0) {
        Write-Host "HIGH ($($high.Count)):" -ForegroundColor Yellow
        $high | ForEach-Object { Write-Host "  ⚠️  $($_.rule): $($_.message)" }
    }
    
    if ($medium.Count -gt 0) {
        Write-Host "MEDIUM ($($medium.Count)):" -ForegroundColor Cyan
        $medium | ForEach-Object { Write-Host "  ℹ️  $($_.rule): $($_.message)" }
    }
    
    exit 1
}

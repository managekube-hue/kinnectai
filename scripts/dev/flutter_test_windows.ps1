 [CmdletBinding(PositionalBinding = $false)]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FlutterArgs,
    [string]$ProjectPath = (Join-Path $PSScriptRoot '..\apps\mobile')
)

$resolvedProjectPath = (Resolve-Path $ProjectPath).Path
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$driveLetter = $null

function Get-FreeDriveLetter {
    foreach ($letter in @('X', 'Y', 'Z', 'W', 'V', 'U')) {
        if (-not (Get-PSDrive -Name $letter -ErrorAction SilentlyContinue)) {
            return $letter
        }
    }

    throw 'No free drive letter available for flutter test mapping.'
}

try {
    if ($repoRoot -match ' ') {
        $driveLetter = Get-FreeDriveLetter
        $substCommand = "subst $driveLetter`: `"$repoRoot`""
        & cmd.exe /d /c $substCommand | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create subst drive for $repoRoot"
        }

        $relativeProjectPath = $resolvedProjectPath.Substring($repoRoot.Length).TrimStart('\')
        Push-Location "$driveLetter`:\$relativeProjectPath"
    } else {
        Push-Location $resolvedProjectPath
    }

    & flutter test @FlutterArgs
    exit $LASTEXITCODE
}
finally {
    Pop-Location
    if ($driveLetter) {
        & cmd.exe /d /c "subst $driveLetter`: /d" | Out-Null
    }
}
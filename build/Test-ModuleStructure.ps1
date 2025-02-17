[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ModuleRoot = Split-Path -Parent $PSScriptRoot

Write-Verbose "Validating module structure in: $ModuleRoot"

# Required files
$RequiredFiles = @(
    'spun.psd1',
    'spun.psm1',
    'README.md',
    'LICENSE'
)

# Required directories
$RequiredDirs = @(
    'src/Public',
    'src/Private',
    'tests',
    'examples'
)

foreach ($file in $RequiredFiles) {
    if (-not (Test-Path -Path (Join-Path -Path $ModuleRoot -ChildPath $file))) {
        throw "Required file missing: $file"
    }
}

foreach ($dir in $RequiredDirs) {
    if (-not (Test-Path -Path (Join-Path -Path $ModuleRoot -ChildPath $dir))) {
        throw "Required directory missing: $dir"
    }
}

# Validate module manifest
Test-ModuleManifest -Path (Join-Path -Path $ModuleRoot -ChildPath 'spun.psd1') -ErrorAction Stop
Write-Verbose "Module manifest is valid"

# Check for required functions
$publicFunctions = Get-ChildItem -Path (Join-Path -Path $ModuleRoot -ChildPath 'src/Public') -Filter '*.ps1'
if ($publicFunctions.Count -eq 0) {
    throw "No public functions found"
}

Write-Host "✓ Module structure validation passed" -ForegroundColor Green

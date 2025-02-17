<#
.SYNOPSIS
    Runs local tests and validations for the spun module.
.DESCRIPTION
    This script executes build analysis (via build.ps1), runs Pester tests,
    validates the module structure, tests module import, and outputs a SHA256 hash
    for spun.psd1. Use this script before pushing commits to the repository.
.EXAMPLE
    pwsh ./scripts/LocalTest.ps1
#>

# Ensure current directory is the module root
Set-Location -Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")

Write-Host "Running local tests and validations for spun..." -ForegroundColor Cyan

# Run build analysis & tests.
# Calls the build script with Test and Analyze flags.
Write-Host "Executing build script (analysis and tests)..." -ForegroundColor Cyan
./build.ps1 -Analyze -Test

# Validate module structure
Write-Host "Validating module structure..." -ForegroundColor Cyan
./build/Test-ModuleStructure.ps1 -Verbose

# Test module import
Write-Host "Testing module import..." -ForegroundColor Cyan
Import-Module ./spun.psd1 -Force -Verbose

# Run Pester tests
Write-Host "Running Pester tests..." -ForegroundColor Cyan
$config = New-PesterConfiguration
$config.Run.Path = "./tests"
$config.Run.TestExtension = ".Tests.ps1"
$config.Output.Verbosity = "Detailed"
Invoke-Pester -Configuration $config

# Generate SHA256 hash for the module manifest
Write-Host "Generating SHA256 hash for spun.psd1..." -ForegroundColor Cyan
$hash = Get-FileHash -Path "./spun.psd1" -Algorithm SHA256
$hash | Format-List | Out-File -FilePath shasum.txt
Write-Host "SHA256 of spun.psd1:" -ForegroundColor Green
Get-Content -Path shasum.txt

Write-Host "Local tests and validations completed." -ForegroundColor Green

<#
.SYNOPSIS
    Build script for the spun module.
.DESCRIPTION
    Installs dependencies, runs script analysis, and executes tests.
.EXAMPLE
    pwsh ./build.ps1 -Test
#>
#region Build Script

[CmdletBinding()]
param(
    [switch]$Test,
    [switch]$Analyze,
    [switch]$Build
)

# Install dependencies
if (-not (Get-Module -ListAvailable PSScriptAnalyzer)) {
    Install-Module PSScriptAnalyzer -Force
}
if (-not (Get-Module -ListAvailable Pester)) {
    Install-Module Pester -Force
}

# Run PSScriptAnalyzer and only fail on errors
if ($Analyze -or $Build) {
    # Retrieve only Error severity issues
    $analysis = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error
    if ($analysis.Count -gt 0) {
        $analysis | Format-Table -AutoSize
        throw "PSScriptAnalyzer found errors"
    }
}

# Run Pester tests
if ($Test -or $Build) {
    $config = [PesterConfiguration]::Default
    $config.Run.Path = "./tests"
    $config.Run.Exit = $true
    $config.TestResult.Enabled = $true
    $config.Output.Verbosity = 'Detailed'
    
    Invoke-Pester -Configuration $config
    if ($LASTEXITCODE -ne 0) {
        throw "Pester tests failed with exit code: $LASTEXITCODE"
    }
}

#endregion

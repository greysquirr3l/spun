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
    $config = New-PesterConfiguration
    $config.Run.Path = "./tests"
    $config.Run.TestExtension = ".Tests.ps1"
    $config.Output.Verbosity = "Detailed"
    try {
        $result = Invoke-Pester -Configuration $config -PassThru
        if ($result.FailedCount -gt 0) {
            throw "$($result.FailedCount) tests failed."
        }
    }
    catch {
        Write-Error "Pester tests failed: $_"
        throw
    }
}

#endregion

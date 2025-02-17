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

# Run PSScriptAnalyzer
if ($Analyze -or $Build) {
    $analysis = Invoke-ScriptAnalyzer -Path . -Recurse
    if ($analysis) {
        $analysis | Format-Table
        throw "PSScriptAnalyzer found issues"
    }
}

# Run Pester tests
if ($Test -or $Build) {
    $config = New-PesterConfiguration
    $config.Run.Path = "./tests"
    $config.Output.Verbosity = "Detailed"
    $result = Invoke-Pester -Configuration $config -PassThru
    if ($result.FailedCount -gt 0) {
        throw "Pester tests failed"
    }
}

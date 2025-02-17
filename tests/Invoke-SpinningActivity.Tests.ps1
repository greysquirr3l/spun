<#
.SYNOPSIS
    Pester tests for Invoke-SpinningActivity.
.DESCRIPTION
    Tests the enhanced spinner function with various styling options, theme presets,
    and ensures proper cleanup of background jobs.
#>

# Import the module to be tested
Import-Module (Join-Path $PSScriptRoot "..\spun.psd1") -Force

Describe "Invoke-SpinningActivity Function Tests" {

    It "executes the action and cleans up the background job" {
        { Invoke-SpinningActivity -Action { Start-Sleep -Seconds 1 } -Text "Test" } | Should -Not -Throw
        (Get-Job -State Completed -ErrorAction SilentlyContinue) | Should -BeNullOrEmpty
    }

    It "runs with spinner styling options (Prefix, Suffix, Bold, Underline, Elapsed)" {
        { Invoke-SpinningActivity -Action { Start-Sleep -Seconds 1 } -Text "Styled" -Prefix "[ " -Suffix " ]" -ShowElapsed -Bold -Underline -ForegroundColor Red } | Should -Not -Throw
    }

    It "runs with progress bar style without gradient" {
        { Invoke-SpinningActivity -Action { Start-Sleep -Seconds 1 } -Text "Progress" -ProgressBar } | Should -Not -Throw
    }

    It "runs with gradient progress bar and custom gradient" {
        { Invoke-SpinningActivity -Action { Start-Sleep -Seconds 1 } -Text "Gradient" -ProgressBar -GradientProgress -CustomGradient @(160,226,46) -BarLength 20 } | Should -Not -Throw
    }

    It "runs with a theme preset" {
        $theme = @{
            SpinnerChars    = @("◐", "◓", "◑", "◒")
            ForegroundColor = "Cyan"
            BackgroundColor = 236
            Prefix          = "{ "
            Suffix          = " }"
            Bold            = $true
            Underline       = $false
        }
        { Invoke-SpinningActivity -Action { Start-Sleep -Seconds 1 } -Text "ThemeTest" -Theme $theme } | Should -Not -Throw
    }
}

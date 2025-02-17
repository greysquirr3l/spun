# Suppress PSAvoidUsingWriteHost and PSAvoidTrailingWhitespace for spinner functionality.
#region PSScriptAnalyzer Suppressions
# pseditor: disable PSAvoidUsingWriteHost
# pseditor: disable PSAvoidTrailingWhitespace
#endregion

<#
.SYNOPSIS
    Starts the spinner.
.DESCRIPTION
    Initializes a spinner for progress indication. If a spinner is already running, warns and returns $false.
.PARAMETER Text
    The text to display next to the spinner.
.EXAMPLE
    Start-Spinner -Text "Loading..."
#>
function Start-Spinner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    if ($Script:SpinnerJob) {
        Write-Warning -Message "A spinner is already running. Use Stop-Spinner first."
        return $false
    }

    $Script:LastText = $Text
    $Script:SpinnerIndex = 0

    $spinnerBlock = {
        param($Text, $UpdateIntervalMs, $SpinnerChars)
        try {
            $index = 0
            while ($true) {
                $char = $SpinnerChars[$index % $SpinnerChars.Length]
                Write-Host "`r$char $Text" -NoNewline
                $index++
                Start-Sleep -Milliseconds $UpdateIntervalMs
            }
        }
        catch {
            Write-Error "Spinner job failed: $_"
        }
    }

    $Script:SpinnerJob = Start-Job -ScriptBlock $spinnerBlock -ArgumentList $Text, 100, $Script:SpinnerChars
    return $true
}

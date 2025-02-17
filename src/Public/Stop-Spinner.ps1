#region PSScriptAnalyzer Suppressions
# pseditor: disable PSAvoidUsingWriteHost
# pseditor: disable PSAvoidTrailingWhitespace
# pseditor: disable PSUseShouldProcessForStateChangingFunctions
#endregion

#region Updated Stop-Spinner using Write-Progress
<#
.SYNOPSIS
    Stops the spinner.
.DESCRIPTION
    Stops and disposes the timer, and signals completion via Write-Progress.
.EXAMPLE
    Stop-Spinner
#>
function Stop-Spinner {
    if ($Script:SpinnerTimer) {
        $Script:SpinnerTimer.Stop()
        $Script:SpinnerTimer.Dispose()
        Remove-Variable -Name SpinnerTimer -Scope Script -ErrorAction SilentlyContinue
        Write-Progress -Activity $Script:SpinnerText -Completed
    }
}
#endregion

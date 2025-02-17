#region PSScriptAnalyzer Suppressions
# pseditor: disable PSAvoidUsingWriteHost
# pseditor: disable PSAvoidTrailingWhitespace
# pseditor: disable PSUseShouldProcessForStateChangingFunctions
#endregion

function Stop-Spinner {
    [CmdletBinding()]
    param(
        [switch]$Clear
    )

    if ($Script:SpinnerJob) {
        Stop-Job -Job $Script:SpinnerJob
        Remove-Job -Job $Script:SpinnerJob
        $Script:SpinnerJob = $null

        if ($Clear) {
            Write-Host "`r$((" " * ($Script:LastText.Length + 2)))`r" -NoNewline
        } else {
            Write-Host ""
        }
    }
}

# Suppress PSAvoidUsingWriteHost and PSAvoidTrailingWhitespace for spinner functionality.
#region PSScriptAnalyzer Suppressions
# pseditor: disable PSAvoidUsingWriteHost
# pseditor: disable PSAvoidTrailingWhitespace
#endregion

#region Updated Spinner using Write-Progress
<#
.SYNOPSIS
    Starts the spinner using Write-Progress.
.DESCRIPTION
    Uses a .NET System.Timers.Timer to update Write-Progress with a rotating character.
    If a spinner is already running, it warns and returns $false.
.PARAMETER Text
    The text to display in the progress activity.
.PARAMETER UpdateIntervalMs
    The update interval in milliseconds (default is 50).
.EXAMPLE
    Start-Spinner -Text "Loading..."
#>
function Start-Spinner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [int]$UpdateIntervalMs = 50
    )
    if ($Script:SpinnerTimer) {
        Write-Warning "A spinner is already running. Use Stop-Spinner first."
        return $false
    }
    $Script:SpinnerText = $Text
    $Script:SpinnerCounter = 0
    $Script:SpinnerChars = @("|","/","-","\")
    $Script:SpinnerTimer = New-Object System.Timers.Timer $UpdateIntervalMs
    $Script:SpinnerTimer.AutoReset = $true
    $Script:OnTimer = [System.Timers.ElapsedEventHandler]{
        $char = $Script:SpinnerChars[$Script:SpinnerCounter % $Script:SpinnerChars.Length]
        Write-Progress -Activity $Script:SpinnerText -Status $char -PercentComplete (($Script:SpinnerCounter % 100))
        $Script:SpinnerCounter++
    }
    $Script:SpinnerTimer.add_Elapsed($Script:OnTimer)
    $Script:SpinnerTimer.Start()
    return $true
}
#endregion

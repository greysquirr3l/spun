#region PSScriptAnalyzer Suppressions
# pseditor: disable PSAvoidUsingWriteHost
# pseditor: disable PSAvoidTrailingWhitespace
#endregion

function Write-SpinnerChar {
    [CmdletBinding()]
    param(
        [string]$Text
    )

    $spinner = $Script:SpinnerChars[$Script:SpinnerIndex++ % $Script:SpinnerChars.Length]
    $Script:LastText = $Text

    Write-Host "`r$spinner $Text" -NoNewline
}

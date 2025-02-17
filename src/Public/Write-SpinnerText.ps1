<#
.SYNOPSIS
    Updates the spinner text.
.DESCRIPTION
    Changes the text displayed by the spinner. Emits a warning if no spinner is running.
.PARAMETER Text
    The new text to display.
.EXAMPLE
    Write-SpinnerText -Text "Still working..."
#>
function Write-SpinnerText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    if (-not $Script:SpinnerJob) {
        Write-Warning -Message "No spinner is currently running. Use Start-Spinner first."
        return
    }

    $Script:LastText = $Text
    Write-Host "`r$($Script:SpinnerChars[$Script:SpinnerIndex % $Script:SpinnerChars.Length]) $Text" -NoNewline
}

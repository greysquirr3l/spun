<#
.SYNOPSIS
    Updates the spinner text.
.DESCRIPTION
    Refreshes the spinner’s progress activity text.
    Emits a warning if no spinner is running.
.PARAMETER Text
    The new text to display.
.EXAMPLE
    Write-SpinnerText -Text "Processing data..."
#>
function Write-SpinnerText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    if (-not $Script:SpinnerTimer) {
        Write-Warning "No spinner is currently running. Use Start-Spinner first."
        return
    }

    $Script:SpinnerText = $Text
}

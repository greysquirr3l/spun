function Write-SpinnerText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )
    
    if (-not $Script:SpinnerJob) {
        Write-Warning "No spinner is currently running. Use Start-Spinner first."
        return
    }
    
    Write-SpinnerChar -Text $Text
}

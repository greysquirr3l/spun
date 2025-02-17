function Start-Spinner {
    <#
    .SYNOPSIS
        Starts a new spinner animation with specified text.
    
    .DESCRIPTION
        Creates a new background job that displays a spinning animation
        alongside the specified text, useful for showing progress during
        long-running operations.
    
    .PARAMETER Text
        The text to display next to the spinner.
    
    .PARAMETER UpdateIntervalMs
        The interval in milliseconds between spinner animation updates.
        Default is 100ms.
    
    .EXAMPLE
        Start-Spinner -Text "Loading..."
        
        Displays a spinner with "Loading..." text.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [int]$UpdateIntervalMs = 100
    )
    
    if ($Script:SpinnerJob) {
        Write-Warning "A spinner is already running. Use Stop-Spinner first."
        return
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

    $Script:SpinnerJob = Start-Job -ScriptBlock $spinnerBlock -ArgumentList $Text, $UpdateIntervalMs, $Script:SpinnerChars

    # Ensure the job started successfully
    if (-not $Script:SpinnerJob) {
        Write-Error "Failed to start spinner job"
        return
    }

    # Start receiving job output immediately
    $Script:SpinnerJob | Receive-Job -Wait -AutoRemoveJob:$false
}

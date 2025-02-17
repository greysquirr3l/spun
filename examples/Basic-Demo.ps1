$modulePath = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path $modulePath 'spun.psd1')

# Basic usage
Start-Spinner -Text "Loading..."
Start-Sleep -Seconds 2
Write-SpinnerText "Still working..."
Start-Sleep -Seconds 2
Stop-Spinner

# Process files example
Start-Spinner "Processing files..."
1..5 | ForEach-Object {
    Write-SpinnerText "Processing file $_..."
    Start-Sleep -Milliseconds 500
}
Stop-Spinner -Clear

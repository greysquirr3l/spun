# This demo runs each spinner/progress variant in sequence to demonstrate all available options.

# Import the module using a relative path from the examples folder
$ModuleManifest = Join-Path $PSScriptRoot "..\spun.psd1"
if (-not (Test-Path $ModuleManifest)) { throw "Module manifest not found at: $ModuleManifest" }
Import-Module $ModuleManifest -Force -Verbose -ErrorAction Stop

Clear-Host
Write-Host "Demo: Running All Spinner/Progress Options" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# Option 1: Simple Spinner with Braille characters, Bold+Underline, with Elapsed Time and custom Prefix/Suffix
Write-Host "`n[Option 1] Simple Spinner (Braille, Bold+Underline, Elapsed)" -ForegroundColor Cyan
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 3 } `
    -Text "Loading..." -Prefix "[ " -Suffix " ]" -ShowElapsed -Bold -Underline -ForegroundColor Green

# Option 2: Simple Spinner with Classic characters and a Background Color
Write-Host "`n[Option 2] Simple Spinner (Classic, with Background Color)" -ForegroundColor White
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 3 } `
    -Text "Updating..." -SpinnerType Classic -ForegroundColor Yellow -BackgroundColor 238

# Option 3: Standard Progress Bar (using Write-Progress)
Write-Host "`n[Option 3] Standard Progress Bar" -ForegroundColor Green
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 2 } -Text "Downloading files..." -ProgressBar

# Option 4: Gradient Progress Bar with a Custom Gradient
Write-Host "`n[Option 4] Gradient Progress Bar (Custom Gradient)" -ForegroundColor Yellow
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 3 } `
    -Text "Processing data..." -ProgressBar -GradientProgress -BarLength 30 -CustomGradient @(160,226,46)

# Option 5: Textual Progress Bar ("27% [====--------------------] 62.7s" format)
Write-Host "`n[Option 5] Textual Progress Bar" -ForegroundColor Magenta
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 3 } `
    -Text "Transferring..." -ProgressBar -TextualProgress -BarLength 40

# Option 6: Spinner with Theme Preset
Write-Host "`n[Option 6] Spinner with Theme Preset" -ForegroundColor White
$myTheme = @{
    SpinnerChars    = @("◐", "◓", "◑", "◒")
    ForegroundColor = "Cyan"
    BackgroundColor = 236
    Prefix          = "{ "
    Suffix          = " }"
    Bold            = $true
    Underline       = $false
}
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 3 } -Text "Applying theme..." -Theme $myTheme

Write-Host "`nDemo completed!" -ForegroundColor Green

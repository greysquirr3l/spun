<#
.SYNOPSIS
    Executes an activity while showing an animated spinner or progress bar with extra styling options.
.DESCRIPTION
    Runs the specified script block as a background job and displays an animated spinner
    or a progress bar. When –ProgressBar is set, you can optionally enable –GradientProgress
    or –TextualProgress to show a custom gradient or a textual progress bar in the format:
        27% [========----------------------] 62.7s
    Additional parameters allow for styling via prefix, suffix, elapsed time display,
    ANSI bold/underline, and a theme.
.PARAMETER Action
    The script block to execute.
.PARAMETER Text
    The text to display alongside the spinner or progress indicator.
.PARAMETER UpdateIntervalMs
    The update interval in milliseconds.
.PARAMETER ProgressBar
    If set, use a progress bar style instead of a simple spinner.
.PARAMETER TextualProgress
    If set (with –ProgressBar), displays a custom textual progress bar.
.PARAMETER GradientProgress
    When using a progress bar, if set, display a custom gradient progress bar.
.PARAMETER BarLength
    Length of the progress bar (used with –GradientProgress or –TextualProgress). Default is 30.
.PARAMETER ForegroundColor
    For spinner output; valid values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed,
    DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White.
.PARAMETER BackgroundColor
    (Optional) ANSI background color for spinner output (as a number from 0-255).
.PARAMETER SpinnerType
    Choose spinner type; valid values: "Braille" (default) or "Classic" (|,/,–,\).
.PARAMETER SpinnerChars
    Optional array of spinner characters. Overrides –SpinnerType if provided.
.PARAMETER Prefix
    Optional text prefix to display before the spinner.
.PARAMETER Suffix
    Optional text suffix to display after the spinner.
.PARAMETER ShowElapsed
    If set, displays elapsed time next to the spinner.
.PARAMETER Bold
    If set, renders spinner text in bold (via ANSI codes).
.PARAMETER Underline
    If set, renders spinner text underlined (via ANSI codes).
.PARAMETER CustomGradient
    Optional array of ANSI 256 color codes to use for the gradient progress bar.
.PARAMETER Theme
    Optional hashtable to define a theme (keys: SpinnerChars, ForegroundColor,
    BackgroundColor, Prefix, Suffix, Bold, Underline, etc.)
.EXAMPLE
    Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Loading..." -Prefix "[" -Suffix "]" -ShowElapsed -Bold
.EXAMPLE
    Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Downloading..." -ProgressBar -TextualProgress -BarLength 40
#>
function Invoke-SpinningActivity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$Action,
        [Parameter(Mandatory=$false)]
        [string]$Text = "Processing...",
        [Parameter(Mandatory=$false)]
        [int]$UpdateIntervalMs = 50,
        [Parameter(Mandatory=$false)]
        [switch]$ProgressBar,
        [Parameter(Mandatory=$false)]
        [switch]$TextualProgress,
        [Parameter(Mandatory=$false)]
        [switch]$GradientProgress,
        [Parameter(Mandatory=$false)]
        [int]$BarLength = 30,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Black","DarkBlue","DarkGreen","DarkCyan","DarkRed","DarkMagenta",
                     "DarkYellow","Gray","DarkGray","Blue","Green","Cyan","Red","Magenta","Yellow","White")]
        [string]$ForegroundColor = "Gray",
        [Parameter(Mandatory=$false)]
        [int]$BackgroundColor,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Braille","Classic")]
        [string]$SpinnerType = "Braille",
        [Parameter(Mandatory=$false)]
        [string[]]$SpinnerChars,
        [Parameter(Mandatory=$false)]
        [string]$Prefix = "",
        [Parameter(Mandatory=$false)]
        [string]$Suffix = "",
        [Parameter(Mandatory=$false)]
        [switch]$ShowElapsed,
        [Parameter(Mandatory=$false)]
        [switch]$Bold,
        [Parameter(Mandatory=$false)]
        [switch]$Underline,
        [Parameter(Mandatory=$false)]
        [int[]]$CustomGradient,
        [Parameter(Mandatory=$false)]
        [hashtable]$Theme
    )
    
    # If a theme is provided, override parameters with theme values
    if ($Theme) {
        if ($Theme.ContainsKey('SpinnerChars')) { $SpinnerChars = $Theme.SpinnerChars }
        if ($Theme.ContainsKey('ForegroundColor')) { $ForegroundColor = $Theme.ForegroundColor }
        if ($Theme.ContainsKey('BackgroundColor')) { $BackgroundColor = $Theme.BackgroundColor }
        if ($Theme.ContainsKey('Prefix')) { $Prefix = $Theme.Prefix }
        if ($Theme.ContainsKey('Suffix')) { $Suffix = $Theme.Suffix }
        if ($Theme.ContainsKey('Bold')) { $Bold = $Theme.Bold }
        if ($Theme.ContainsKey('Underline')) { $Underline = $Theme.Underline }
    }
    
    # Set default spinner characters if not provided
    if (-not $SpinnerChars) {
        if ($SpinnerType -eq "Classic") {
            $SpinnerChars = @("|", "/", "-", "\")
        }
        else {
            $SpinnerChars = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
        }
    }
    
    $index = 0
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $ansiReset = "`e[0m"
    
    function Get-Styling {
        param($Bold, $Underline, $ForegroundColor, $BackgroundColor)
        $style = ""
        if ($Bold) { $style += "`e[1m" }
        if ($Underline) { $style += "`e[4m" }
        if ($ForegroundColor) {
            $fgMap = @{
                Black = 30; DarkBlue = 34; DarkGreen = 32; DarkCyan = 36;
                DarkRed = 31; DarkMagenta = 35; DarkYellow = 33; Gray = 37;
                DarkGray = 90; Blue = 94; Green = 92; Cyan = 96;
                Red = 91; Magenta = 95; Yellow = 93; White = 97
            }
            if ($fgMap.ContainsKey($ForegroundColor)) { $style += "`e[$($fgMap[$ForegroundColor])m" }
        }
        if ($BackgroundColor) { $style += "`e[48;5;${BackgroundColor}m" }
        return $style
    }
    
    $styleCode = Get-Styling -Bold:$Bold -Underline:$Underline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor

    $job = Start-Job -ScriptBlock $Action
    if (-not $job) { throw "Failed to start background job" }
    
    if ($ProgressBar) {
        if ($TextualProgress) {
            # Custom textual progress bar style: "27% [========----------------------] 62.7s"
            while ((Get-Job -Id $job.Id -ErrorAction SilentlyContinue).State -ne 'Completed') {
                $percent = [math]::Min($index % 101, 100)
                $filled = [math]::Floor(($BarLength * $percent) / 100)
                $empty = $BarLength - $filled
                $bar = ("=" * $filled) + ("-" * $empty)
                $elapsed = [math]::Round($stopwatch.Elapsed.TotalSeconds, 1)
                $progressStr = "$percent% [$bar] ${elapsed}s"
                Write-Host "`r$Prefix$progressStr$Suffix" -NoNewline
                Start-Sleep -Milliseconds $UpdateIntervalMs
                $index++
            }
            Write-Host "`r" -NoNewline
        }
        elseif ($GradientProgress) {
            $gradColors = if ($CustomGradient) { $CustomGradient } else { @(196,226,46) }
            while ((Get-Job -Id $job.Id -ErrorAction SilentlyContinue).State -ne 'Completed') {
                $percent = $index % 101  
                $filled = [math]::Floor(($BarLength * $percent) / 100)
                $barStr = "$Prefix["
                for ($i = 1; $i -le $BarLength; $i++) {
                    if ($i -le $filled) {
                        if ($i -le $BarLength/3) { $colorCode = $gradColors[0] }  
                        elseif ($i -le (2 * $BarLength)/3) { $colorCode = $gradColors[1] }  
                        else { $colorCode = $gradColors[2] }
                        $barStr += "$([char]27)[38;5;${colorCode}m█$ansiReset"
                    }
                    else { $barStr += " " }
                }
                $barStr += "] $percent%$Suffix"
                $char = $SpinnerChars[$index % $SpinnerChars.Length]
                Write-Host "`r$barStr $char" -NoNewline
                Start-Sleep -Milliseconds $UpdateIntervalMs
                $index++
            }
            Write-Host "`r" -NoNewline
        }
        else {
            while ((Get-Job -Id $job.Id -ErrorAction SilentlyContinue).State -ne 'Completed') {
                $char = $SpinnerChars[$index % $SpinnerChars.Length]
                Write-Progress -Activity "$Prefix$Text" -Status "$char $([math]::Round($index % 100))%$Suffix" -PercentComplete ($index % 100)
                Start-Sleep -Milliseconds $UpdateIntervalMs
                $index++
            }
            Write-Progress -Activity "$Prefix$Text" -Completed
        }
    }
    else {
        while ((Get-Job -Id $job.Id -ErrorAction SilentlyContinue).State -ne 'Completed') {
            $char = $SpinnerChars[$index % $SpinnerChars.Length]
            $elapsed = if ($ShowElapsed) { " " + $stopwatch.Elapsed.ToString("hh\:mm\:ss") } else { "" }
            Write-Host "`r$Prefix$styleCode$char $Text$elapsed$ansiReset$Suffix" -NoNewline
            Start-Sleep -Milliseconds $UpdateIntervalMs
            $index++
        }
        Write-Host "`r" -NoNewline
    }
    $stopwatch.Stop()
    Receive-Job $job | Out-Null
    Remove-Job $job -ErrorAction SilentlyContinue | Out-Null
}

# spun

A minimalist PowerShell spinner module for displaying progress during long-running operations.

## Overview

**spun** provides a variety of animated progress indicators for PowerShell scripts. You can choose from:

- **Simple Spinners:** Display a continuously updating icon using either "Braille" (default) or "Classic" characters.
- **Standard Progress Bar:** Uses built-in Write-Progress.
- **Gradient Progress Bar:** A custom progress bar with a gradient (using ANSI 256 colors).
- **Textual Progress Bar:** A progress bar rendered as text in the format:  
  `27% [========----------------------] 62.7s`

Additionally, the module offers styling options such as prefix/suffix text, elapsed time display, and ANSI styling (bold, underline, and foreground/background colors). You can also supply a complete theme preset via a hashtable.

## Demo

Below is a rendered GIF demonstrating several of the module’s features in action:

![spun Demo](render1739811188813.gif)

*Note: The demo GIF shows all options sequentially, including simple spinners with styling, various progress bars (standard, gradient, textual), and theme presets.*

## Installation

Clone the repository and import the module:

```powershell
Import-Module "path\to\spun.psd1" -Force
```

Or install from the repository if published.

## Usage

### Basic Example

```powershell
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Loading..."
```

### Detailed Options

#### Spinner Options:
- **-Action**: *[scriptblock]* – The long-running action to execute.
- **-Text**: *[string]* – Text to display alongside the spinner.
- **-UpdateIntervalMs**: *[int]* – Milliseconds between frame updates (default: 50).
- **-Prefix / -Suffix**: *[string]* – Optional text displayed before/after the spinner.
- **-ShowElapsed**: *[switch]* – Display elapsed time alongside the spinner.
- **-Bold, -Underline**: *[switch]* – Render text in bold or underlined via ANSI codes.
- **-ForegroundColor**: *[string]* – Spinner text color.
- **-BackgroundColor**: *[int]* – ANSI 256 background color code.
- **-SpinnerType**: *[string]* – "Braille" (default) or "Classic" (i.e. |, /, -, \).
- **-SpinnerChars**: *[string[]]* – Custom spinner characters.
- **-Theme**: *[hashtable]* – Predefined styling (keys: SpinnerChars, ForegroundColor, BackgroundColor, Prefix, Suffix, Bold, Underline).

#### Progress Bar Options (used with -ProgressBar):
- **-ProgressBar**: *[switch]* – Enable progress bar mode.
- **-TextualProgress**: *[switch]* – Display a textual progress indicator in the format:  
  `27% [========----------------------] 62.7s`
- **-GradientProgress**: *[switch]* – Use a gradient for the progress bar.
- **-BarLength**: *[int]* – Length (in characters) of the progress bar (default: 30).
- **-CustomGradient**: *[int[]]* – An array of ANSI 256 color codes (e.g., @(160,226,46)) used for the gradient.

## Supported Colors

For the **-ForegroundColor** parameter, valid values are:
- Black  
- DarkBlue  
- DarkGreen  
- DarkCyan  
- DarkRed  
- DarkMagenta  
- DarkYellow  
- Gray  
- DarkGray  
- Blue  
- Green  
- Cyan  
- Red  
- Magenta  
- Yellow  
- White  

## Examples

### Example 1: Simple Spinner with Styling

```powershell
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } `
    -Text "Loading..." -Prefix "[ " -Suffix " ]" -ShowElapsed -Bold -Underline -ForegroundColor Green
```

### Example 2: Standard Progress Bar

```powershell
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Downloading files..." -ProgressBar
```

### Example 3: Gradient Progress Bar

```powershell
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Processing data..." `
    -ProgressBar -GradientProgress -BarLength 30 -CustomGradient @(160,226,46)
```

### Example 4: Textual Progress Bar

```powershell
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Transferring..." `
    -ProgressBar -TextualProgress -BarLength 40
```

### Example 5: Using a Theme Preset

```powershell
$myTheme = @{
    SpinnerChars    = @("◐", "◓", "◑", "◒")
    ForegroundColor = "Cyan"
    BackgroundColor = 236
    Prefix          = "{ "
    Suffix          = " }"
    Bold            = $true
    Underline       = $false
}
Invoke-SpinningActivity -Action { Start-Sleep -Seconds 5 } -Text "Applying theme..." -Theme $myTheme
```

## Helper Functions

In addition to **Invoke-SpinningActivity**, the module also includes basic spinner functions:
- **Start-Spinner**
- **Stop-Spinner**
- **Write-SpinnerText**

## Development and Testing

- **Tests:** Run Pester tests in the `tests` directory:
  ```powershell
  Invoke-Pester -Path ./tests/Invoke-SpinningActivity.Tests.ps1
  ```
- **Build Script:** Use the build scripts in the `build` folder to analyze, test, and validate module structure.
- **CI:** GitHub Actions CI pipeline is configured in `.github/workflows/ci.yml`.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

## License

This project is licensed under the terms in [LICENSE](./LICENSE).

## Contributing

Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on how to contribute.

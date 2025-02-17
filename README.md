# spun

A minimalist PowerShell spinner module for displaying progress during long-running operations.

## Installation

```powershell
# Clone the repository
git clone https://github.com/nickcampbell/spun.git

# Import the module
Import-Module ./spun/spun.psm1
```

## Usage

### Basic Usage

```powershell
# Start a spinner
Start-Spinner -Text "Loading..."

# Do some work
Start-Sleep -Seconds 2

# Update the spinner text
Write-SpinnerText "Still working..."

# Do more work
Start-Sleep -Seconds 2

# Stop the spinner
Stop-Spinner
```

### Parameters

#### Start-Spinner
- `-Text` (Required): The text to display next to the spinner
- `-UpdateIntervalMs` (Optional): Spinner update interval in milliseconds (default: 100)

#### Write-SpinnerText
- `-Text` (Required): New text to display next to the spinner

#### Stop-Spinner
- `-Clear` (Optional): Clear the spinner line when stopping

### Examples

```powershell
# Process files with progress
Start-Spinner "Processing files..."
foreach ($file in Get-ChildItem) {
    Write-SpinnerText "Processing $($file.Name)..."
    # Process file
    Start-Sleep -Milliseconds 500
}
Stop-Spinner

# API calls with spinner
Start-Spinner "Fetching data from API..."
try {
    # Make API call
    Start-Sleep -Seconds 2
    Write-SpinnerText "Processing response..."
    Start-Sleep -Seconds 1
}
finally {
    Stop-Spinner
}
```

For more examples, check out the [Basic-Demo.ps1](examples/Basic-Demo.ps1) script in the examples directory.

## Features

- Unicode spinner characters for smooth animation
- Simple API with just three commands
- Automatic cleanup on interruption
- Works in standard PowerShell consoles
- Minimal overhead and dependencies

## Requirements

- PowerShell 5.1 or higher
- Windows PowerShell or PowerShell Core
- Console that supports Unicode characters
- Pester 5.0 or higher (for running tests)

## Testing

### Running Tests

```powershell
# Install Pester if not already installed
Install-Module -Name Pester -Force -SkipPublisherCheck

# Run all tests
Invoke-Pester ./tests

# Run tests with detailed output
Invoke-Pester ./tests -Output Detailed
```

### Test Structure
Tests are located in the `./tests` directory and follow the Pester convention:
- Unit tests: `*.Tests.ps1`
- Integration tests: `*.Integration.Tests.ps1`

### Writing Tests
When contributing, please ensure:
- Each new feature has corresponding tests
- Tests follow the Arrange-Act-Assert pattern
- Mock external dependencies when appropriate
- Tests are properly documented

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - feel free to use in your own projects!

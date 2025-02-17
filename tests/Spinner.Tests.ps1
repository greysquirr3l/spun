BeforeAll {
    # Update to use the module manifest
    Import-Module "$PSScriptRoot/../spun.psd1" -Force -Verbose
}

Describe "Spinner Module" {
    It "Should start a spinner" {
        $result = Start-Spinner -Text "Loading..."
        $result | Should -Be $true
        Stop-Spinner | Out-Null
    }

    It "Should update spinner text" {
        Start-Spinner -Text "Loading..."
        Write-SpinnerText "Still working..."
        # Additional validations can be added
        Stop-Spinner | Out-Null
    }

    It "Should stop the spinner" {
        Start-Spinner -Text "Loading..."
        Stop-Spinner | Out-Null
        $Script:SpinnerJob | Should -BeNullOrEmpty
    }
}

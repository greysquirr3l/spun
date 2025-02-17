BeforeAll {
    $ModulePath = (Resolve-Path "$PSScriptRoot/..").Path
    Import-Module "$ModulePath/spun.psd1" -Force
}

Describe "Spun Module Tests" {
    BeforeEach {
        # Ensure spinner is stopped before each test
        Stop-Spinner -ErrorAction SilentlyContinue
    }
    
    Context "Start-Spinner" {
        It "Creates a new spinner job" {
            Start-Spinner -Text "Test"
            $Script:SpinnerJob | Should -Not -BeNullOrEmpty
            Stop-Spinner
        }
        
        It "Warns when starting multiple spinners" {
            Start-Spinner -Text "Test"
            { Start-Spinner -Text "Another" } | Should -Warn
            Stop-Spinner
        }
    }
    
    Context "Write-SpinnerText" {
        It "Updates spinner text" {
            Start-Spinner -Text "Initial"
            Write-SpinnerText -Text "Updated"
            $Script:LastText | Should -Be "Updated"
            Stop-Spinner
        }
        
        It "Warns when no spinner is running" {
            { Write-SpinnerText -Text "Test" } | Should -Warn
        }
    }
    
    Context "Stop-Spinner" {
        It "Stops the spinner job" {
            Start-Spinner -Text "Test"
            Stop-Spinner
            $Script:SpinnerJob | Should -BeNullOrEmpty
        }
        
        It "Handles multiple stop calls gracefully" {
            { Stop-Spinner; Stop-Spinner } | Should -Not -Throw
        }
    }
}

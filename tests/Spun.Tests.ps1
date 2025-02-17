BeforeAll {
    # Import the module manifest to load exported commands
    $ModulePath = (Resolve-Path "$PSScriptRoot/..").Path
    Import-Module "$ModulePath/spun.psd1" -Force -Verbose
}

Describe "Spun Module Tests" {
    BeforeEach {
        # Ensure spinner is stopped before each test
        Stop-Spinner -ErrorAction SilentlyContinue
    }

    Context "Start-Spinner" {
        It "Creates a new spinner job" {
            $result = Start-Spinner -Text "Loading..."
            $result | Should -Be $true
            # Cleanup
            Stop-Spinner | Out-Null
        }

        It "Warns when starting multiple spinners" {
            Start-Spinner -Text "Loading..."
            $warningMsg = $null
            Start-Spinner -Text "Duplicate" -WarningVariable warningMsg -WarningAction SilentlyContinue
            $warningMsg | Should -BeLike "*spinner is already running*"
            Stop-Spinner | Out-Null
        }
    }

    Context "Write-SpinnerText" {
        BeforeEach {
            Stop-Spinner -ErrorAction SilentlyContinue
        }

        It "Updates spinner text" {
            Start-Spinner -Text "Loading..."
            Write-SpinnerText "Still working..."
            Stop-Spinner
        }

        It "warns when no spinner is running" {
            $warning = $null
            Write-SpinnerText "Test" -WarningVariable warning -WarningAction SilentlyContinue
            $warning | Should -Match "No spinner is currently running"
        }
    }

    Context "Stop-Spinner" {
        It "Stops the spinner job" {
            Start-Spinner -Text "Loading..."
            Stop-Spinner | Out-Null
            $Script:SpinnerJob | Should -BeNullOrEmpty
        }

        It "Handles multiple stop calls gracefully" {
            Start-Spinner -Text "Loading..."
            Stop-Spinner | Out-Null
            { Stop-Spinner } | Should -Not -Throw
        }
    }
}

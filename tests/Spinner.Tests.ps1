BeforeAll {
    Import-Module $PSScriptRoot/../spun.psm1
}

Describe "Spinner Module" {
    It "Should start a spinner" {
        Start-Spinner -Text "Test"
        $spinner = Get-Variable -Scope Script -Name spinner -ValueOnly
        $spinner.Active | Should -Be $true
        $spinner.Text | Should -Be "Test"
        Stop-Spinner
    }

    It "Should update spinner text" {
        Start-Spinner -Text "Initial"
        Write-SpinnerText "Updated"
        $spinner = Get-Variable -Scope Script -Name spinner -ValueOnly
        $spinner.Text | Should -Be "Updated"
        Stop-Spinner
    }

    It "Should stop the spinner" {
        Start-Spinner -Text "Test"
        Stop-Spinner
        $spinner = Get-Variable -Scope Script -Name spinner -ValueOnly
        $spinner.Active | Should -Be $false
    }
}

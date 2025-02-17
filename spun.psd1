@{
    RootModule = 'spun.psm1'
    ModuleVersion = '0.1.0'
    GUID = '12345678-1234-1234-1234-123456789012'
    Author = 'greysquirr3l'
    CompanyName = 'Your Company'
    Description = 'A minimalist spinner module.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Start-Spinner',
        'Write-SpinnerText',
        'Stop-Spinner',
        'Invoke-SpinningActivity'  # Ensure this new function is exported
    )
    PrivateData = @{
        PSData = @{
            Tags = @('spinner', 'progress', 'console')
            ProjectUri = 'https://github.com/greysquirr3l/spun'
            LicenseUri = 'https://github.com/greysquirr3l/spun/blob/main/LICENSE'
            ReleaseNotes = 'https://github.com/greysquirr3l/spun/blob/main/CHANGELOG.md'
        }
    }
}

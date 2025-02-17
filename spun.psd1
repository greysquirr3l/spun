@{
    RootModule = 'src/spun.psm1'
    ModuleVersion = '0.1.0'
    GUID = '12345678-1234-1234-1234-123456789012'
    Author = 'Nick Campbell'
    Description = 'A minimalist PowerShell spinner module'
    PowerShellVersion = '5.1'
    # Don't explicitly list functions, let the module handle exports
    FunctionsToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('spinner', 'progress', 'console')
            ProjectUri = 'https://github.com/nickcampbell/spun'
            LicenseUri = 'https://github.com/nickcampbell/spun/blob/main/LICENSE'
            ReleaseNotes = 'https://github.com/nickcampbell/spun/blob/main/CHANGELOG.md'
        }
    }
}

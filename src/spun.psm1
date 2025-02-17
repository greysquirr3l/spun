#region Module Variables
$Script:SpinnerJob = $null
$Script:SpinnerChars = '⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'
$Script:SpinnerIndex = 0
$Script:LastText = ""
#endregion

#region Import Functions
$Public = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public' '*.ps1') -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private' '*.ps1') -ErrorAction SilentlyContinue )

foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}
#endregion

Export-ModuleMember -Function $Public.BaseName

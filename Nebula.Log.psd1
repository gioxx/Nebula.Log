@{
    RootModule           = 'Nebula.Log.psm1'
    ModuleVersion        = '1.0.7'
    GUID                 = '4777f87e-f3fd-4404-bc3a-c724e6c12552'
    Author               = 'Giovanni Solone'
    Description          = 'A lightweight and configurable logging module for PowerShell scripts, supports multiple log levels and file rotation.'

    # Minimum required PowerShell (PS 5.1 works; better with PS 7+)
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    RequiredAssemblies   = @()
    FunctionsToExport    = @(
        'Test-ActivityLog',
        'Write-Log'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @('Log-Message')

    PrivateData          = @{
        PSData = @{
            Tags         = @('Logging', 'PowerShell', 'Nebula', 'Utilities')
            ProjectUri   = 'https://github.com/gioxx/Nebula.Log'
            LicenseUri   = 'https://opensource.org/licenses/MIT'
            IconUri      = 'https://raw.githubusercontent.com/gioxx/Nebula.Log/main/icon.png'
            ReleaseNotes = @'
- Improved: Now compatible with PowerShell 5.1 and later.
- Improved: Refactored module structure for better maintainability.
- Improved: Made LogLocation optional (caller script dir or current dir).
- Improved: LogFileName default moved to param. Added directory auto-creation.
- Improved: Switched log rotation to Move-Item. Added UTF-8 writer with retries.
- Improved: Added -MaxFileSizeKB, -AsJson, -PassThru. Console coloring.
- Improved: Added color coding per level.
- Added: -Color switch (console coloring is now opt-in; default: no colors).
'@
        }
    }
}

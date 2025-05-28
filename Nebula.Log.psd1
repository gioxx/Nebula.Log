@{
    RootModule        = 'Nebula.Log.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '4777f87e-f3fd-4404-bc3a-c724e6c12552'
    Author            = 'Giovanni Solone'
    Description       = 'Structured logging module for PowerShell scripts. Supports multiple log levels and file rotation.'

    PowerShellVersion = '7.0'

    FunctionsToExport = @(
        'Test-ActivityLog',
        'Write-Log'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('Log-Message')

    PrivateData = @{
        PSData = @{
            Tags         = @('Logging', 'PowerShell', 'Nebula', 'Utilities')
            LicenseUri   = 'https://opensource.org/licenses/MIT'
            ProjectUri   = 'https://github.com/gioxx/Nebula.Log'
            IconUri      = 'https://raw.githubusercontent.com/gioxx/Nebula.Log/main/icon.png'
            ReleaseNotes = @'
Initial release of Nebula.Log:
- Write-Log function with support for INFO, SUCCESS, WARNING, DEBUG, ERROR
- Automatic log file archiving if it exceeds 512KB
- Alias Log-Message for compatibility
- Test-ActivityLog to validate logging setup
'@
        }
    }
}

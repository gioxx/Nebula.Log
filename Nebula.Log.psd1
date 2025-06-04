@{
    RootModule        = 'Nebula.Log.psm1'
    ModuleVersion     = '1.0.4'
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
            Tags            = @('Logging', 'PowerShell', 'Nebula', 'Utilities')
            License         = 'MIT'
            ProjectUri      = 'https://github.com/gioxx/Nebula.Log'
            Icon            = 'icon.png'
            Readme          = 'README.md'
            ReleaseNotes    = @'
- Fixed issue with Test-ActivityLog function not writing to the log file.
'@
        }
    }
}

@{
    RootModule        = 'Nebula.Log.psm1'
    ModuleVersion     = '1.0.6'
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
- From now, you can use -TryFix parameter to attempt to fix unwritable log files in Test-ActivityLog.
- Added WriteOnlyToFile switch to allow writing to the log file without outputting to the console.
'@
        }
    }
}

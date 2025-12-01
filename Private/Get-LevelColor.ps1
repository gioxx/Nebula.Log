function Get-LevelColor {
    param([Parameter(Mandatory)][ValidateSet('INFO', 'SUCCESS', 'WARNING', 'DEBUG', 'ERROR')] [string] $Level)
    switch ($Level) {
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'DEBUG' { 'Cyan' }
        'ERROR' { 'Red' }
        default { 'White' }
    }
}
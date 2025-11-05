function Test-ActivityLog {
    <#
    .SYNOPSIS
        Test if the activity log file is writable; optionally try to fix it.
    .PARAMETER LogLocation
        Optional. Where log files are stored. Defaults to caller script directory or current location.
    .PARAMETER LogFileName
        Optional. The log file name (default: 'activity.log').
    .PARAMETER TryFix
        If specified, attempt to fix unwritable log file by archiving and recreating it.
    .EXAMPLE
        Test-ActivityLog -LogFileName "activity.log"
    #>
    [CmdletBinding()]
    param (
        [string] $LogLocation, # optional
        [ValidatePattern('\S')]
        [string] $LogFileName = 'activity.log',
        [switch] $TryFix
    )

    # Resolve (and ensure) the log directory even when not provided
    try {
        $resolvedLogDir = Resolve-LogLocation -LogLocation $LogLocation -EnsureExists
    } catch {
        Write-Error $_
        return [pscustomobject]@{ Status = 'KO'; Path = $null; Error = "$($_)" }
    }

    $logFilePath = Join-Path -Path $resolvedLogDir -ChildPath $LogFileName

    if (-not (Test-Path -LiteralPath $logFilePath)) {
        Write-Error "Log file does not exist: $logFilePath"
        return [pscustomobject]@{ Status = 'KO'; Path = $logFilePath; Error = 'NotFound' }
    }

    try {
        # Try logging a test message
        Write-Log -LogLocation $resolvedLogDir -LogFileName $LogFileName `
            -Message "Test activity log message." -Level "INFO" `
            -WriteToFile -ErrorAction Stop
        return [pscustomobject]@{ Status = 'OK'; Path = $logFilePath; Fixed = $false }
    } catch {
        Write-Warning "Initial log write failed: $_"

        if ($TryFix) {
            Write-Warning "Attempting to fix log file ..."
            try {
                $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
                $archiveName = "$($LogFileName).unwritable.$timestamp.bak"
                $archivedLog = Join-Path $resolvedLogDir $archiveName
                Move-Item -LiteralPath $logFilePath -Destination $archivedLog -Force
                Write-Warning "Log file archived to: $archivedLog"

                # Attempt to log again
                Write-Log -LogLocation $resolvedLogDir -LogFileName $LogFileName `
                    -Message "Test activity log message after fix." -Level "INFO" `
                    -WriteToFile -ErrorAction Stop
                return [pscustomobject]@{ Status = 'OK'; Path = (Join-Path $resolvedLogDir $LogFileName); Fixed = $true }
            } catch {
                Write-Error "Auto-fix failed: $_"
                return [pscustomobject]@{ Status = 'KO'; Path = $logFilePath; Error = "$($_)"; Fixed = $false }
            }
        }

        return [pscustomobject]@{ Status = 'KO'; Path = $logFilePath; Error = "$($_)"; Fixed = $false }
    }
}
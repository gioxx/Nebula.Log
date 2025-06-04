<#
.SYNOPSIS
    Logging functions for PowerShell scripts.
.DESCRIPTION
    This module contains functions for logging messages to the console and to a log file.
    It supports different log levels (INFO, SUCCESS, WARNING, DEBUG, ERROR) and allows for archiving log files when they exceed a specified size (512KB).
    The log file is stored in a specified location, and the function can write messages to the console and/or to the log file.
.PARAMETER LogLocation
    The location where log files will be stored.
.PARAMETER Message
    The message to log.
.PARAMETER LogFileName
    The name of the log file (default is 'activity.log').
.PARAMETER Level
    The log level (INFO, SUCCESS, WARNING, DEBUG, ERROR). Default is INFO.
.PARAMETER WriteToFile
    If specified, the message will be written to the log file.
.EXAMPLE
    Write-Log -LogLocation "C:\Logs" -Message "Hello, world!" -Level "INFO" -WriteToFile
    Write-Log -LogLocation "C:\Logs" -Message "An error occurred" -Level "ERROR" -WriteToFile
    
    Test-ActivityLog -LogLocation "C:\Logs" -LogFileName "activity.log"
    This will log messages to the specified log file and console, and test if the logging functionality works correctly.
.NOTES
    Author: Giovanni Solone

    Modification History:
    - 2025/05/28:   Added Test-ActivityLog function to test logging functionality.
    - 2025/05/20:   Added check for log file size (512KB) and archive it with a timestamp if exceeded.
                    Changed function name to Write-Log and set alias Log-Message for backward compatibility.
    - 2025/04/03:   Added Parameter informations to this help.
    - 2025/03/28:   Added LogFileName parameter to specify the name of the log file (if not specified, force use 'activity.log').
    - 2025/03/27:   Initial version (isolation of logging functions from main script).
#>

function Write-Log {
    param (
        [string]$LogLocation,
        [string]$Message,
        [string]$LogFileName,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "DEBUG", "ERROR")]$Level = "INFO",
        [switch]$WriteToFile
    )

    # Set default filename if not specified
    if (-not $LogFileName -or $LogFileName -eq "") {
        $LogFileName = "activity.log"
    }

    # Verify that the path exists
    if (-not (Test-Path $LogLocation)) {
        Write-Error "Log location does not exist: $LogLocation"
        return
    }

    $logFilePath = Join-Path $LogLocation $LogFileName

    # Check if the file exceeds 512KB (524288 bytes)
    if (Test-Path $logFilePath) {
        $fileInfo = Get-Item $logFilePath
        if ($fileInfo.Length -ge 524288) {
            $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
            $archivedLog = Join-Path $LogLocation "$($LogFileName).$timestamp.bak"
            try {
                Rename-Item -Path $logFilePath -NewName $archivedLog -Force
            } catch {
                Write-Error "Unable to archive log file: $_"
            }
        }
    }

    $formattedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
    $formattedMessage | Out-Host
    if ($WriteToFile) {
        try {
            Add-Content -Path $logFilePath -Value $formattedMessage -ErrorAction Stop
        } catch {
            Write-Error "Failed to write to log file: $_"
            throw  # Re-throw the exception to be caught by calling function
        }
    }    
}

function Test-ActivityLog {
    param (
        [string]$LogLocation,
        [string]$LogFileName
    )

    # Set default filename if not specified
    if (-not $LogFileName -or $LogFileName -eq "") {
        $LogFileName = "activity.log"
    }

    # Verify that the path exists
    if (-not (Test-Path $LogLocation)) {
        Write-Error "Log location does not exist: $LogLocation"
        return "KO"
    }

    $logFilePath = Join-Path $LogLocation $LogFileName

    if (Test-Path $logFilePath) {
        try {
            # Attempt to write a test message to the log file
            Log-Message -LogLocation $LogLocation -LogFileName $LogFileName `
                -Message "Test activity log message." -Level "INFO" `
                -WriteToFile -ErrorAction Stop
            return "OK"
        } catch {
            # Catch any error, including access denied
            Write-Error "Failed to write to activity log: $_"
            return "KO"
        }
    } else {
        Write-Error "Log file does not exist: $logFilePath"
        return "KO"
    }
}

Set-Alias -Name Log-Message -Value Write-Log
Export-ModuleMember -Function Write-Log -Alias Log-Message
Export-ModuleMember -Function Test-ActivityLog
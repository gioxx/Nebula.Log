function Write-Log {
    <#
    .SYNOPSIS
        Log a message to console and/or a log file with levels and auto-rotation.
    .PARAMETER LogLocation
        Optional. Where log files will be stored. Defaults to caller script directory or current location.
    .PARAMETER Message
        The message to log.
    .PARAMETER LogFileName
        Optional. The log file name (default: 'activity.log').
    .PARAMETER Level
        The log level (INFO, SUCCESS, WARNING, DEBUG, ERROR). Default is INFO.
    .PARAMETER WriteToFile
        If specified, the message will be written to the log file.
    .PARAMETER WriteOnlyToFile
        If specified, the message will be written only to the log file and not output to the console.
    .PARAMETER MaxFileSizeKB
        Optional. Max file size (in KB) before rotation; default 512.
    .PARAMETER AsJson
        Optional. Emit JSON Lines to file/console: {"timestamp":"...","level":"...","message":"..."}.
    .PARAMETER PassThru
        Optional. Return a PSCustomObject with Timestamp, Level, Message, Path.
    .PARAMETER Color
        If specified, colorize console output based on log level.
    .EXAMPLE
        Write-Log -Message "Hello, world!" -Level INFO -WriteToFile
        Writes to console and to '.\activity.log' under the caller script folder or current directory.
    #>
    [CmdletBinding()]
    param (
        [string] $LogLocation, # optional
        [Parameter(Mandatory)][string] $Message,
        [ValidatePattern('\S')]
        [string] $LogFileName = 'activity.log', # default here (really optional)
        [ValidateSet('INFO', 'SUCCESS', 'WARNING', 'DEBUG', 'ERROR')]
        [string] $Level = 'INFO',
        [switch] $WriteToFile,
        [switch] $WriteOnlyToFile,
        [int] $MaxFileSizeKB = 512,
        [switch] $AsJson,
        [switch] $PassThru,
        [switch] $Color
    )

    # Sanitize/validate file name (avoid illegal characters across platforms)
    $invalid = [IO.Path]::GetInvalidFileNameChars()
    if ($LogFileName.IndexOfAny($invalid) -ge 0) {
        throw "LogFileName contains invalid characters."
    }

    # Resolve (and ensure) the log directory even when not provided
    try {
        $resolvedLogDir = Resolve-LogLocation -LogLocation $LogLocation -EnsureExists
    } catch {
        Write-Error $_
        return
    }

    $logFilePath = Join-Path -Path $resolvedLogDir -ChildPath $LogFileName

    # Rotate if size >= threshold
    if ($WriteToFile -and (Test-Path -LiteralPath $logFilePath)) {
        try {
            $fileInfo = Get-Item -LiteralPath $logFilePath -ErrorAction Stop
            $threshold = [math]::Max(1, $MaxFileSizeKB) * 1KB
            if ($fileInfo.Length -ge $threshold) {
                $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
                $archiveName = "$LogFileName.$timestamp.bak"
                $archivePath = Join-Path $resolvedLogDir $archiveName
                try {
                    Move-Item -LiteralPath $logFilePath -Destination $archivePath -Force -ErrorAction Stop
                } catch {
                    Write-Error "Unable to rotate/archive log file: $_"
                }
            }
        } catch {
            Write-Error "Unable to inspect log file: $_"
        }
    }

    # Format message
    $now = Get-Date
    $formattedMessage = if ($AsJson) {
        @{ timestamp = $now.ToString('o'); level = $Level; message = $Message } | ConvertTo-Json -Compress
    } else {
        "$($now.ToString('yyyy-MM-dd HH:mm:ss')) [$Level] $Message"
    }

    # Console output (unless WriteOnlyToFile)
    if (-not $WriteOnlyToFile) {
        if ($Color) {
            $fg = Get-LevelColor -Level $Level
            Write-Host $formattedMessage -ForegroundColor $fg
        } else {
            Write-Host $formattedMessage
        }
    }

    # File output
    if ($WriteToFile) {
        try {
            Add-LineToFile -Path $logFilePath -Line $formattedMessage
        } catch {
            Write-Error "Failed to write to log file: $_"
            throw
        }
    }

    if ($PassThru) {
        return [pscustomobject]@{
            Timestamp = $now
            Level     = $Level
            Message   = $Message
            Path      = if ($WriteToFile) { $logFilePath } else { $null }
        }
    }
}

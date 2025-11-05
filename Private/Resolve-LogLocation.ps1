function Resolve-LogLocation {
    <#
    .SYNOPSIS
        Resolve the effective log directory and optionally create it.
    .PARAMETER LogLocation
        Candidate directory. If empty, try caller script directory, else current directory.
    .PARAMETER EnsureExists
        Create the directory if it doesn't exist.
    #>
    [CmdletBinding()]
    param(
        [string] $LogLocation,
        [switch] $EnsureExists
    )

    # If provided explicitly, use it.
    if ($LogLocation -and $LogLocation.Trim()) {
        $target = $LogLocation
    } else {
        # Try to detect the caller script path from the call stack (first frame with a ScriptName != this module).
        $modulePath = $PSCommandPath
        $callerScript = $null
        try {
            $frames = Get-PSCallStack 2>$null
            if ($frames) {
                foreach ($f in $frames) {
                    if ($f.InvocationInfo -and $f.InvocationInfo.ScriptName) {
                        $sn = $f.InvocationInfo.ScriptName
                        if ($sn -and $sn -ne $modulePath) {
                            $callerScript = $sn
                            break
                        }
                    }
                }
            }
        } catch {
            # No action; we'll fall back below.
        }

        if ($callerScript) {
            $target = Split-Path -Path $callerScript -Parent
        } else {
            # As a last resort, use the current file system location.
            $target = (Get-Location).Path
        }
    }

    if ($EnsureExists) {
        if (-not (Test-Path -LiteralPath $target)) {
            try {
                $null = New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop
            } catch {
                throw "Unable to create log directory '$target': $_"
            }
        }
    }

    return $target
}
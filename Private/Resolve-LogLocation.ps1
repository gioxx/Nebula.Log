function Resolve-LogLocation {
    <#
    .SYNOPSIS
        Resolve the effective log directory and optionally create it.
    .DESCRIPTION
        If LogLocation is not provided, this inspects the call stack and returns the first
        caller script directory that is OUTSIDE of the module root. If none is found
        (e.g., interactive console), it falls back to the current location.
    #>
    [CmdletBinding()]
    param(
        [string] $LogLocation,
        [switch] $EnsureExists
    )

    # Use explicit path if provided
    if ($LogLocation -and $LogLocation.Trim()) {
        $target = $LogLocation
    } else {
        # Try to infer from call stack, skipping frames that belong to this module
        # $script:ModuleRoot is set in Nebula.Log.psm1 before dot-sourcing Private/
        $moduleRoot = $script:ModuleRoot
        $callerScript = $null

        try {
            $frames = Get-PSCallStack 2>$null
            if ($frames) {
                foreach ($f in $frames) {
                    $sn = $f.InvocationInfo.ScriptName
                    if (-not [string]::IsNullOrWhiteSpace($sn)) {
                        # Normalize both paths for robust comparison
                        $snFull = [IO.Path]::GetFullPath($sn)
                        $isInsideModule = ($moduleRoot -and ( [IO.Path]::GetFullPath($moduleRoot).TrimEnd('\', '/') -and $snFull.StartsWith([IO.Path]::GetFullPath($moduleRoot), $true, [Globalization.CultureInfo]::InvariantCulture) ))

                        if (-not $isInsideModule) {
                            $callerScript = $snFull
                            break
                        }
                    }
                }
            }
        } catch {
            # ignore and fall back
        }

        if ($callerScript) {
            $target = Split-Path -Path $callerScript -Parent
        } else {
            # 3) Fallback: current working directory
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

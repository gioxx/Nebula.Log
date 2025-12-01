# Nebula.Log.psm1
$script:ModuleRoot = $PSScriptRoot

# --- Load Private helpers first (NOT exported) ---
$privateDir = Join-Path $PSScriptRoot 'Private'
if (Test-Path $privateDir) {
    Get-ChildItem -Path $privateDir -Filter '*.ps1' -File | ForEach-Object {
        try {
            . $_.FullName  # dot-source
        } catch {
            throw "Failed to load Private script '$($_.Name)': $($_.Exception.Message)"
        }
    }
}

# --- Load Public entry points (will be exported) ---
$publicDir = Join-Path $PSScriptRoot 'Public'
if (Test-Path $publicDir) {
    Get-ChildItem -Path $publicDir -Filter '*.ps1' -File | ForEach-Object {
        try {
            . $_.FullName  # dot-source
        } catch {
            throw "Failed to load Public script '$($_.Name)': $($_.Exception.Message)"
        }
    }
}

# --- Aliases & Exports -------------------------------------------------------
$existing = Get-Alias -Name 'Log-Message' -ErrorAction SilentlyContinue
if (-not $existing -or $existing.ResolvedCommandName -ne 'Write-Log') {
    Set-Alias -Name Log-Message -Value Write-Log -Force
}
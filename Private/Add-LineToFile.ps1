function Add-LineToFile {
    <#
    .SYNOPSIS
        Append a line to a file using UTF-8 (no BOM) with simple retries.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string] $Line,
        [int] $Retries = 3,
        [int] $DelayMs = 100
    )

    $enc = [System.Text.UTF8Encoding]::new($false)
    for ($i = 0; $i -lt $Retries; $i++) {
        try {
            $sw = [System.IO.StreamWriter]::new($Path, $true, $enc)
            $sw.WriteLine($Line)
            $sw.Dispose()
            return
        }
        catch {
            if ($i -eq ($Retries - 1)) { throw }
            Start-Sleep -Milliseconds $DelayMs
        }
        finally {
            if ($sw) { $sw.Dispose() }
        }
    }
}
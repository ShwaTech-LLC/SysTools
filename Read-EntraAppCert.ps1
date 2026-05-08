<#
    .SYNOPSIS
    Reads the certificate.json file exported by `New-EntraAppCert.ps1` into an object for use.
    .PARAMETER Path
    The path to the certificate.json file.
#>
function Read-EntraAppCert {
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    if( $Path ) {
        # OK
    } else {
        throw "Path to certificate metadata $Path does not exist"
    }
    $obj = Get-Content $Path -Raw | ConvertFrom-Json
    if( $obj.CertThumb ) {
        # OK
    } else {
        Write-Warning "Certificate metadata $Path does not contain a thumbprint"
    }
    Write-Output $obj
}
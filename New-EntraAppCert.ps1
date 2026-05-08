<#
    .SYNOPSIS
    Generates a 256-bit RSA public and private key for app-based authentication with Microsoft Azure Entra ID.
    .PARAMETER AppRegistrationName
    The name of the App Registration in Microsoft Azure Entra ID.
    This must match the name exactly.
    .PARAMETER ExportPrivateKey
    An optional parameter to specify if you want to export the private key associated with the certificate.
#>
param(
    [Parameter(Mandatory)]
    [string]
    $AppRegistrationName,
    [switch]
    $ExportPrivateKey
)

# Assert preconditions
if( $PSVersionTable.PSVersion.Major -ne 5 ) {
    throw "You must use PowerShell 5"
}
if( -not $AppRegistrationName ) {
    throw "You must specify an app registration name"
}

# Create a password for the certificate file
Add-Type -AssemblyName "System.Web"
$certSec = [System.Web.Security.Membership]::GeneratePassword( 32, 0 )
$certStr = ConvertTo-SecureString -String $certSec -Force -AsPlainText

# Generate the certificate
$cert = New-SelfSignedCertificate -CertStoreLocation "Cert:\CurrentUser\My" -Subject "CN=$AppRegistrationName" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256
if( -not $cert ) {
    throw "Certificate was not generated"
}

# Export the certificate files
$cer = Export-Certificate -Cert $cert -FilePath (Join-Path -Path $PSScriptRoot -ChildPath "$AppRegistrationName-public.cer")
if( $ExportPrivateKey ) {
    $pfx = Export-PfxCertificate -Cert $cert -FilePath (Join-Path -Path $PSScriptRoot -ChildPath "$AppRegistrationName-private.pfx") -Password $certStr
}

# Exporting the thumbprint
Write-Host "App registration name:  $AppRegistrationName"
Write-Host "Certificate password:   $certSec"
Write-Host "Certificate thumbprint: $($cert.Thumbprint)"
if( $ExportPrivateKey ) {
    Write-Host "Private key file:       $($pfx.FullName)"
}
Write-Host "Public key file:        $($cer.FullName)"
Write-Host "Certificate details:    $PSScriptRoot\certificate.json"

# Construct the certificate details data structure
$outFile = Join-Path -Path $PSScriptRoot -ChildPath 'certificate.json'
$certDetails = [PSCustomObject]@{
    CertApp = $AppRegistrationName
    CertPw = if( $ExportPrivateKey ) { $certSec } else { 'not exported' }
    CertThumb = $cert.Thumbprint
    CertPvt = if( $ExportPrivateKey ) { $pfx.FullName } else { 'not exported' }
    CertPub = $cer.FullName
    CertDetails = $outFile
}

# Save the details to a file
if( Test-Path $outFile ) {
    $answer = Read-Host "$outFile already exists, overwrite? [N/y]"
    if( $answer -ne 'y' ) {
        exit
    } else {
        $certDetails | ConvertTo-Json | Out-File $outFile -Force
    }
} else {
    $certDetails | ConvertTo-Json | Out-File $outFile -Force
}
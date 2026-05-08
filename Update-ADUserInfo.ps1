<#
    .SYNOPSIS
    Updates a user's information using their UPN.
    .PARAMETER UserPrincipalName
    The user principal name for the account in the Active Directory domain.
    .PARAMETER JobTitle
    Optional. Their Job Title. Not updated if not specified or blank.
    .PARAMETER Department
    Optional. Their Department name. Not updated if not specified or blank.
    .PARAMETER Company
    Optional. Their Company name. Not updated if not specified or blank.
    .PARAMETER MobilePhone
    Optional. Their mobile phone number. Not updated if not specified or blank.
    .PARAMETER StreetAddress
    Optional. Their street address. Not updated if not specified or blank.
#>
param(
    [Parameter(Mandatory)]
    [string]
    $UserPrincipalName,
    [string]
    $JobTitle,
    [string]
    $Department,
    [string]
    $Company,
    [string]
    $MobilePhone,
    [string]
    $StreetAddress
)

# Gatekeeper for Windows PowerShell
if( $PSVersionTable.PSVersion.Major -ne 5 ) {
    throw "This script requires Windows PowerShell 5.1"
}

# Test for the ActiveDirectory module
if( Get-Module ActiveDirectory ) {
    # OK
} else {
    Import-Module ActiveDirectory
    if( Get-Module ActiveDirectory ) {
        # OK
    } else {
        throw "You do not have the ActiveDirectory module installed"
    }
}

# Find the user in Active Directory
$user = Get-ADUser -Filter "*" | Where-Object { $_.UserPrincipalName -eq $UserPrincipalName }
if( $user ) {
    if( $JobTitle ) {
        $user | Set-ADUser -Title $JobTitle
    }
    if( $Department ) {
        $user | Set-ADUser -Department $Department
    }
    if( $Company ) {
        $user | Set-ADUser -Company $Company
    }
    if( $MobilePhone ) {
        $user | Set-ADUser -MobilePhone $MobilePhone
    }
    if( $StreetAddress ) {
        $user | Set-ADUser -StreetAddress $StreetAddress
    }
} else {
    Write-Warning "User $UserPrincipalName not found"
}
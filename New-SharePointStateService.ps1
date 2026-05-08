<#
    .SYNOPSIS
    Creates a new State Service application in the farm.
    .PARAMETER DatabaseName
    The name to use for the database. Defaults to sp_state_service
#>
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $DatabaseName = 'sp_state_service'
)

if( $PSVersionTable.PSVersion.Major -ne 5 ) {
    throw 'You must use the SharePoint Management Shell in Windows PowerShell'
}

$isSpShell = Get-PSSnapIn -Registered | Where-Object { $_.Name -eq 'Microsoft.SharePoint.PowerShell' }
if( -not $isSpShell ) {
    throw 'You must use the SharePoint Management Shell in Windows PowerShell'
}

[Security.Principal.WindowsPrincipal]$myPrincipal = [Security.Principal.WindowsIdentity]::GetCurrent()
if( $myPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ) ) {
    # OK
} else {
    throw 'You must run the SharePoint Management Shell with Administrative privileges'
}

function New-Proxy {
    param(
        [Parameter(Mandatory,Position = 0)]
        $StateService
    )
    $proxy = New-SPStateServiceApplicationProxy -Name 'State Service Proxy' -ServiceApplication $stateService -DefaultProxyGroup
    if( $proxy ) {
        Write-Host 'State Service created successfully' -ForegroundColor Green
    } else {
        Write-Host 'State Service created successfully, but Proxy failed, please retry' -ForegroundColor Yellow
    }
}

$stateService = Get-SPStateServiceApplication
if( $stateService ) {
    Write-Host 'Your farm already has a State Service application' -ForegroundColor Yellow
    $proxy = Get-SPStateServiceApplicationProxy
    if( $proxy ) {
        Write-Host 'Your farm already has a State Service application proxy' -ForegroundColor Yellow
    } else {
        New-Proxy $stateService
    }
} else {
    $database = New-SPStateServiceDatabase -Name $DatabaseName
    $stateService = New-SPStateServiceApplication -Name 'State Service' -Database $database
    if( $stateService ) {
        New-Proxy $stateService
    } else {
        throw 'State Service application creation failed'
    }
}
<#
	.SYNOPSIS
	Grants app-only write permissions to a given site in SharePoint Online.
	.DESCRIPTION
	There are three required data points in order to grant an app access to a SharePoint Online site collection: the App ID (or Client ID), the App Name, and the URL of the SharePoint Online site. In order for this to work, there must be an Entra application registration which has been granted the Sites.Selected API permission from the SharePoint group of permissions. Admin consent must be granted. You must have PnP.PowerShell installed. You must run this using a Global Admin account. You must configure PnP.PowerShell in your tenant.
    .PARAMETER AppId
    The System.Guid for the application registration (Client ID) in Microsoft Entra.
    .PARAMETER AppName
    The display name for the application registration in Microsoft Entra.
    .PARAMETER SiteUrl
    The URL of the SharePoint Online site collection to which you want to grant write access.
    .EXAMPLE
    .\Grant-AppSitePermissions.ps1 -AppId '69d2d970-4e1d-467c-b74d-e4501e120151' -AppName 'Put The Name Of Your App Here' -SiteUrl 'https://yourtenant.sharepoint.com/sites/thesite'
#>
param(
    [Parameter(Mandatory)]
    [string]
    $AppId,
    [Parameter(Mandatory)]
    [string]
    $AppName,
    [Parameter(Mandatory)]
    [string]
    $SiteUrl
)

# Check the PowerShell host
if( $PSVersionTable.PSVersion.Major -ne 7 ) {
    Write-Host "This script was designed for PowerShell 7, it may not work correctly in PowerShell $($PSVersionTable.PSVersion.ToString())" -ForegroundColor Yellow
}

# Check for the PnP.PowerShell module
$installed = Get-InstalledModule | Where-Object { $_.Name -eq 'PnP.PowerShell' }
if( $installed ) {
    Import-Module PnP.PowerShell
} else {
    Write-Host 'You must install the PnP.PowerShell module' -ForegroundColor Red
    exit
}

# Connect to the site to set the context
Connect-PnPOnline -Url $SiteUrl -Interactive

# Ask the PnP.PowerShell module to grant write permissions to the app
Grant-PnPAzureADAppSitePermission -AppId $AppId -DisplayName $AppName -Permissions Write
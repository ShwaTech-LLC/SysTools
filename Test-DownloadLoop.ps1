<#
	.SYNOPSIS
	This script downloads the .NET Framework installer in an infinite loop.
	.NOTES
	This script starts with an exit command to stop you from running it.
	You will need to remove this exit command to use this script.
#>
exit
$link = 'https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.301/dotnet-sdk-9.0.301-win-x64.exe'
$fn = 'dotnet-sdk-9.0.301-win-x64.exe'
$count = 1
while( $true ) {
	Write-Host "Download Attempt [$count]"
	& curl @('-O',"$link")
	Start-Sleep -Seconds 12
	Remove-Item $fn
	$count += 1
}
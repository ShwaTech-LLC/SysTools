<#
	.SYNOPSIS
	Uses the file length to identify files in the target directory tree to rename based on the master tree.
	.PARAMETER Master
	The absolute path to the master directory tree.
	.PARAMETER Target
	The absolute path to the target directory tree.
	.PARAMETER Detail
	A flag which will output rename operations and errors.
#>
param(
	[string]
	$Master,
	[string]
	$Target,
	[switch]
	$Detail
)

# Import the file name sync handler
$code = Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath 'FileNameSync.cs') -Raw
$null = Add-Type -TypeDefinition $code -Language CSharp

# Instantiate the handler object
$handler = New-Object 'ShwaTech.SysTools.FnSync.SyncHandler'
$handler.MasterPath = $Master
$handler.TargetPath = $Target
if( -not $handler.PathsExist() ) {
	throw "One or more paths do not exist."
}

# Define the path separator based on the OS
if( $PSVersionTable.PSVersion.Major -eq 5 ) {
	$IsWindows = $true
	$IsLinux = $false
	$IsMacOS = $false
}
if( $IsLinux ) { $pathSeparator = '/' }
if( $IsWindows) { $pathSeparator = '\' }
if( $IsMacOS ) { $pathSeparator = '/' }
[ShwaTech.SysTools.FnSync.SyncHandler]::PathSeparator = $pathSeparator

# Sync file names from master to target
if($Detail) { [ShwaTech.SysTools.FnSync.SyncHandler]::Verbose = $true }
$handler.SyncNames()
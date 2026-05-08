<#
    .SYNOPSIS
    Clears the specified watchFolder for lingering files and moves them to the safetyFolder if they linger too long.
    .DESCRIPTION
    This script will restart the SharePoint Timer Service to release the file locks on the files in the watch folder.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $WatchFolder,
    [Parameter(Mandatory=$true)]
    [string]
    $SafetyFolder,
    [ValidateRange(1,9999)]
    [int]
    $CutoffMinutes = 1,
    [switch]
    $RecycleSpTimer
)

if( -not (TestPath -$WatchFolder) ) {
    throw "Illegal watch folder"
}
if( -not (Test-Path $SafetyFolder) ) {
    throw "Illegal safety folder"
}

# Declare the cutoff time
$cutoff = [System.DateTime]::Now.AddMinutes( (-1*($CutoffMinutes)) )

# Get all the items in the watch folder older than the cutoff time
$items = Get-ChildItem -Path $WatchFolder | Where-Object { $_.CreationTime -lt $cutoff }

# If there are any lingering files, stop the SharePoint Timer Service, move the files, then start it back up
if( $items ) {
    if( $RecycleSpTimer ) {
        & net @('stop','sptimerv4')
    }
    $items | Move-Item -Destination $SafetyFolder
    if( $RecycleSpTimer ) {
        & net @('start','sptimerv4')
    }
}
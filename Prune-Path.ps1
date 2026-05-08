<#
    .SYNOPSIS
    Prunes (removes empty directories) from a folder path.
    .PARAMETER Path
    The path on disk to prune.
    .PARAMETER Quiet
    Prune in quiet mode, do not output deleted folders.
#>
param(
    [Parameter(Mandatory)]
    [string]
    $Path,
    [switch]
    $Quiet
)
$folderTree = Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath '.\FolderTree.cs') -Raw
Add-Type -TypeDefinition $folderTree -Language CSharp
$pruner = New-Object -TypeName 'ShwaTech.FolderTree' -ArgumentList @($Path)
if( -not $pruner ) { exit }
if( $Quiet ) { $pruner.Quiet = $true }
$pruner.Prune()
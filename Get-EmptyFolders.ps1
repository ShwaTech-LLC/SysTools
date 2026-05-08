param(
    [Parameter(Mandatory)]
    $Path = (Get-Location)
)
$outputFile = Join-Path -Path $PSScriptRoot -ChildPath "EmptyFolders.txt"
Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
    $children = Get-ChildItem -Path $_
    if( $children ) {
        # Not empty
    } else {
        Out-File -InputObject ($_.FullName) -Path $outputFile -Append
    }
}
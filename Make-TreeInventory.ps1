param(
    [Parameter(Mandatory)]
    $Path
)

if( $Path ) {
    if( -not (Test-Path $Path) ) {
        throw "Path $Path does not exist"
    }
} else {
    throw "No Path defined"
}

$target = Join-Path -Path $PSScriptRoot -ChildPath "inventory.csv"
if( Test-Path $target ) {
    $a = Read-Host -Prompt "$target already exists, overwrite? [N/y]"
    if( $a -ne 'y' ) {
        exit
    }
    Remove-Item -Path $target -Force
}

Get-ChildItem -Path $Path -Recurse -File | ForEach-Object {
    $hash = Get-FileHash $_
    [PSCustomObject]@{
        Name = $_.Name
        FullName = $_.FullName
        Length = $_.Length
        Hash = $hash.Hash
        Algorithm = $hash.Algorithm
    } | Export-Csv -Path $target -Append
}
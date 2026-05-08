Write-Host "This script will load your DuplicateFiles.csv report and delete ALL duplicates"
$answer = Read-Host "Do you want to proceed? [N/y]"
if( $answer -ne 'y' ) {
    exit
}
$path = Join-Path -Path $PSScriptRoot -ChildPath "DuplicateFiles.csv"
if( Test-Path $path ) {
    $files = Import-Csv $path
    $total = $files.Length
    $counter = 0
    $files | ForEach-Object {
        $file = $_.Duplicate
        if( Test-Path $file ) {
            Remove-Item -Path $file -Force
        }
        $counter++
        Write-Progress -Activity "Deleting Duplicates" -Status "In Progress ($counter of $total)" -PercentComplete ($counter / $total * 99.9)
    }
} else {
    throw "Could not find DuplicateFiles.csv"
}
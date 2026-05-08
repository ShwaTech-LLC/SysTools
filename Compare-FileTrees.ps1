<#
    .SYNOPSIS
    Detects duplicate files between two folder trees.
    .PARAMETER Master
    The master folder tree to scan first and treat as the primary source.
    .PARAMETER Duplicate
    The duplicates folder tree to scan second and treat as the duplicates location.
    .PARAMETER HardLimit
    An optional, arbitrary hard limit of files to process before stopping, if you want to limit the processing time.
    .PARAMETER TreatZeroAsDuplicate
    An optional switch to include zero-length files in the duplicates report.
    .PARAMETER TrackMasterDuplicates
    An optional switch to track duplicate files in the master directory.
    .PARAMETER OutputFile
    An optional name for the output report file. By default, this is FileTreeReport.csv
#>
param(
    [Parameter(Mandatory)]
    [string]
    $Master,
    [Parameter(Mandatory)]
    [string]
    $Duplicate,
    [ValidateRange(1,999999999)]
    [int]
    $HardLimit = [Int32]::MaxValue,
    [switch]
    $TreatZeroAsDuplicate,
    [switch]
    $TrackMasterDuplicates,
    [string]
    $OutputFile = "FileTreeReport.csv"
)

# Assertions
if( -not (Test-Path $Master) ) {
    throw "Path specified as Master $Master does not exist or cannot be accessed"
}
if( -not (Test-Path $Duplicate) ) {
    throw "Path specified as Duplicate $Duplicate does not exist or cannot be accessed"
}
if( $Master -eq $Duplicate ) {
    throw "You cannot specify the same path for both Master and Duplicate"
}

# Setup the report of duplicates
$report = Join-Path -Path $PSScriptRoot -ChildPath $OutputFile
if( Test-Path $report ) {
    Remove-Item -Path $report -Confirm
    if( Test-Path $report ) {
        Write-Warning "Output file not cleared, errors will occur if schema does not match"
    }
}

# Setup variables
$table = @{}
$duplicates = @()
$masterFiles = Get-ChildItem -Path $Master -Recurse -File
$total = $masterFiles.Length
$counter = 0
$hash = $null

# Process the master tree first
foreach( $file in $masterFiles ) {
    if( $file.Length -gt 0 ) {
        try {
            $hash = (Get-FileHash ($file.FullName)).Hash
        } catch {
            $hash = $null
        }
        if( $hash ) {
            if( $table.ContainsKey( $hash ) ) {
                if( $TrackMasterDuplicates ) {
                    $originalFile = $table[$hash]
                    $dupe = [PSCustomObject]@{
                        Original = $originalFile.FullName
                        Duplicate = $file.FullName
                        FileSize = $file.Length
                        Hash = $hash
                    }
                    $duplicates += $dupe
                }
            } else {
                $table.Add( $hash, $file )
            }
        } else {
            Write-Warning "File $($file.FullName) could not be read"
        }
    } else {
        if( $TreatZeroAsDuplicate -and $TrackMasterDuplicates ) {
            $dupe = [PSCustomObject]@{
                Original = $file.FullName
                Duplicate = $file.FullName
                FileSize = $file.Length
                Hash = "zero-length file"
            }
            $duplicates += $dupe
        }
    }
    $counter++
    if( $counter -gt $HardLimit ) {
        break
    }
    Write-Progress -Activity "Building Master Tree" -Status "In Progress ($counter of $total)" -PercentComplete ($counter / $total * 99.9)
}

# Fetch the duplicate tree files and reset variables
$duplicateFiles = Get-ChildItem -Path $Duplicate -Recurse -File
$total = $duplicateFiles.Length
$counter = 0
$hash = $null

# Process the duplicates file tree second
foreach( $file in $duplicateFiles ) {
    if( $file.Length -gt 0 ) {
        try {
            $hash = (Get-FileHash ($file.FullName)).Hash
        } catch {
            $hash = $null
        }
        if( $hash ) {
            if( $table.ContainsKey( $hash ) ) {
                $originalFile = $table[$hash]
                $dupe = [PSCustomObject]@{
                    Original = $originalFile.FullName
                    Duplicate = $file.FullName
                    FileSize = $file.Length
                    Hash = $hash
                }
                $duplicates += $dupe
            } else {
                $table.Add( $hash, $file )
            }
        } else {
            Write-Warning "File $($file.FullName) could not be read"
        }
    } else {
        if( $TreatZeroAsDuplicate ) {
            $dupe = [PSCustomObject]@{
                Original = $file.FullName
                Duplicate = $file.FullName
                FileSize = $file.Length
                Hash = "zero-length file"
            }
            $duplicates += $dupe
        }
    }
    $counter++
    if( $counter -gt $HardLimit ) {
        break
    }
    Write-Progress -Activity "Processing Duplicates Tree" -Status "In Progress ($counter of $total)" -PercentComplete ($counter / $total * 99.9)
}

# Report the duplicates to a file
if( $duplicates ) {
    Write-Host "Exporting duplicates report"
    $duplicates | ForEach-Object {
        Export-Csv -InputObject $_ -Path $report -Append
    }
} else {
    Write-Host "No duplicates found"
}
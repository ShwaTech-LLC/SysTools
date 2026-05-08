<#
    .SYNOPSIS
    Checks for duplicate files in a specific directory.
    .PARAMETER Path
    The Path to search for duplicate files.
    .PARAMETER LiteralPath
    The LiteralPath to search for duplicate files.
    .PARAMETER HardLimit
    A fixed limit to impose on this parser if desired, for example for testing.
    .PARAMETER OutputFile
    The file to output with the results.
#>
param(
    [Parameter(ParameterSetName="Path",Mandatory)]
    [string]
    $Path,
    [Parameter(ParameterSetName="LiteralPath",Mandatory)]
    [string]
    $LiteralPath,
    [Parameter(Mandatory=$false)]
    [ValidateRange(1,999999999)]
    [int]
    $HardLimit = [Int32]::MaxValue,
    [string]
    $OutputFile = "DuplicateFiles.csv"
)

# Assert path access
if( $Path ) {
    if( -not (Test-Path -Path $Path) ) {
        throw "Invalid or inaccessible Path specified"
    }
}

# Assert literal path access
if( $LiteralPath ) {
    if( -not (Test-Path -LiteralPath $LiteralPath ) ) {
        throw "Invalid or inaccessible LiteralPath specified"
    }
}

# Clear the output file first
$report = Join-Path -Path $PSScriptRoot -ChildPath $OutputFile
if( Test-Path $report ) {
    Remove-Item -Path $report -Confirm
    if( Test-Path $report ) {
        Write-Warning "Output file not cleared, errors will occur if schema does not match"
    }
}

# Declare the item manifest table
$manifest = @{}

# Declare the table for storing duplicates
$duplicates = @()

function Write-FileHash {
    param(
        [Parameter(Mandatory=$true)]
        $File,
        [Parameter(Mandatory=$true)]
        [string]
        $Hash
    )
    # Check the manifest for a file with the same hash
    if( $script:manifest.ContainsKey( $Hash ) ) {

        # Flag the duplicate file and pair it to the original
        $original = $script:manifest[$Hash]
        $notes = [PSCustomObject]@{
            Original = $original.FullName
            Duplicate = $File.FullName
            FileSize = $File.Length
            Hash = $Hash
        }
        $script:duplicates += $notes
    } else {
        # Add the original file to the manifest
        $script:manifest.Add( $Hash, $File )
    }
}

# Get all the items in the current directory including all the subfolders and files
$children = if( $Path ) {
    Get-ChildItem -Path $Path -Recurse -File
} elseif( $LiteralPath ) {
    Get-ChildItem -LiteralPath $LiteralPath -Recurse -File
} else {
    throw "No Path or LiteralPath specified"
}

# Generate a manifest of file hashes for every file, this will take a while for large directory trees
$total = $children.Length
$counter = 0
foreach( $child in $children ) {
    # Skip zero-length files
    if( $child.Length -gt 0 ) {
        # Calculate the file hash
        $hash = $null
        try {
            $hash = (Get-FileHash ($child.FullName)).Hash
        } catch {
            $hash = $null
        }
        # Report the file hash or warning
        if( $hash ) {
            Write-FileHash -File $child -Hash $hash
        } else {
            Write-Warning "Failed to read file $($child.FullName)"
        }
    } else {
        # Treat all zero-length files as trash
        $notes = [PSCustomObject]@{
            Original = "zero-length file"
            Duplicate = $child.FullName
            FileSize = 0
            Hash = "zero-length file"
        }
        $duplicates += $notes
    }
    # Increment the file counter and report progress, stop if the hard limit is reached
    $counter++
    if( $counter -gt $HardLimit ) {
        break
    }
    Write-Progress -Activity "Searching for Duplicates" -Status "In Progress ($counter of $total)" -PercentComplete ($counter / $total * 99.9)
}

# Output the report of all the duplicate files, if any were found
if( $duplicates ) {
    Write-Host "Exporting duplicates to duplicates.csv"
    $duplicates | ForEach-Object {
        Export-Csv -InputObject $_ -Path $report -Append
    }
} else {
    Write-Host "No duplicate files found"
}
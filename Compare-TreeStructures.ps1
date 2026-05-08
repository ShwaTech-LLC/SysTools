<#
    .SYNOPSIS
    Identifies in the Destination path that no longer exist in the Source path.
    .PARAMETER Source
    The absolute path to the source data.
    .PARAMETER Destination
    The absolute path to the destination folder.
    .PARAMETER ReportPath
    An optional path to output results to a file. If this file exists, it will be overwritten.
    .PARAMETER Complete
    An optional switch. When specified, all file records are included in the output report, not just missing files.
#>
param(
    [Parameter(Mandatory)]
    [string]
    $Source,
    [Parameter(Mandatory)]
    [string]
    $Destination,
    [string]
    $ReportPath,
    [switch]
    $Complete
)

# Step 1: Assert Pre-Conditions
# Verify the source path, the destination path and formatting

if( $PSVersionTable.PSVersion.Major -lt 7 ) {
    throw "This script requires PowerShell 7 or higher"
}
if( -not (Test-Path $Source) ) {
    throw "Source does not exist"
}
if( -not (Test-Path $Destination) ) {
    throw "Destination does not exist"
}

# Step 2: Normalize path endings
# Ensure that the Source and Destination both end with a trailing slash

if( $IsWindows ) {
    if( -not ($Source.EndsWith( '\' )) ) {
        $Source = "$Source\"
    }
    if( -not ($Destination.EndsWith( '\' )) ) {
        $Destination = "$Destination\"
    }
} else {
    if( -not ($Source.EndsWith( '/' )) ) {
        $Source = "$Source/"
    }
    if( -not ($Destination.EndsWith( '/' )) ) {
        $Destination = "$Destination/"
    }
}

# Step 3: Create the DoesFileExist class instance
# Works around a bug in PS7 that fails to detect exiting files which contain square brackets in their path

$existsCode = @"
using System;
using System.IO;

namespace ShwaTech {
    public class DoesFileExist {
            public bool Exists( string fullPath ) {
            var dst = new FileInfo( fullPath );
            return dst.Exists;
        }
    }
}
"@
Add-Type -TypeDefinition $existsCode -Language CSharp
$exists = New-Object -TypeName "ShwaTech.DoesFileExist"

# Step 4: Clear the output file
# Create the path to the output file and remove it if it exists

if( $ReportPath ) {
    if( Test-Path $ReportPath ) { Remove-Item -Path $ReportPath -Force }
    if( Test-Path $ReportPath ) { throw "Failed to clear $ReportPath" }    
}

# Step 5: Iterate the Destination for missing files
# Check all the files in the destination to see if they no longer exist in the source

Get-ChildItem -Path $Destination -File -Recurse | ForEach-Object {

    # Use string replace method to re-root the file into the source tree
    $sourceFullPath = $_.FullName.Replace( $Destination, $Source )

    # Create a file report datagram on the file itself
    $report = [PSCustomObject]@{
        Source = $sourceFullPath
        Destination = ($_.FullName)
        IsInSourceTree = ($exists.Exists( $sourceFullPath ))
    }

    # Report the file presence to the output report
    if( $Complete ) {
        if( $ReportPath ) {
            Export-Csv -InputObject $report -Path $ReportPath -Append
        } else {
            Write-Output $report
        }
    } else {
        if( -not ($report.IsInSourceTree) ) {
            if( $ReportPath ) {
                Export-Csv -InputObject $report -Path $ReportPath -Append
            } else {
                Write-Output $report
            }
        } else {
            # Do not report
        }
    }
}
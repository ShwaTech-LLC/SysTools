<#
    .SYNOPSIS
    Writes department, job title, and contact information for staff members from a CSV file into Microsoft 365.
    .PARAMETER Path
    The path to the CSV file containing the staff metadata. This script assumes the CSV has the following columns:
    1. Company Email Address (matching the UserPrincipalName for the account in Microsoft 365)
    2. Department
    3. Job Title
    4. Employee Name (used to display messages, but not updated)
    5. Mobile Phone
#>
param(
    [Parameter(Mandatory)]
    [string]
    $Path
)

# Gatekeeper for PowerShell 7
if( $PSVersionTable.PSVersion.Major -lt 7 ) {
    throw "This script requires PowerShell 7"
}

# Validate and fetch the staff metadata
if( Test-Path $Path ) {
    # OK
} else {
    throw "Staff member CSV file $Path does not exist"
}
$staff = Import-Csv $Path

# Load the Graph module
Import-Module Microsoft.Graph
if( Get-Module Microsoft.Graph ) {
    # OK
} else {
    throw 'Failed to load required module Microsoft.Graph'
}

# Connect to the Graph and get all users
Connect-MgGraph -Scopes 'User.ReadWrite.All'
$company = Get-MgUser

# Iterate the collection of staff and update their info in the cloud
foreach( $member in $staff ) {
    if( $member.'Company Email Address' ) {
        $found = $company | Where-Object { $_.UserPrincipalName -eq $member.'Company Email Address' }
        if( $found ) {
            Write-Host "Updating $($found.UserPrincipalName) with Department $($member.Department) and Job Title $($member.'Job Title')"
            Update-MgUser -UserId ($found.Id) -Department ($member.Department) -JobTitle ($member.'Job Title') -MobilePhone ($member.'Mobile Phone')
        } else {
            Write-Warning "$($member.'Company Email Address') not found in company directory"
        }
    } else {
        Write-Warning "$($member.'Employee Name') does not contain a Company Email Address"
    }
}
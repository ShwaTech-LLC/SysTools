param(
	[Parameter(Mandatory)]
	[string]
	$Path,
	[ValidateRange(1,9999)]
	[Parameter(Mandatory)]
	[int]
	$NumberOfFiles,
	[switch]
	$RandomSubFolders,
	[ValidateRange(1,1024)]
	[int]
	$MinimumFileSize,
	[ValidateRange(1,1024)]
	[int]
	$MaximumFileSize
)
if( -not (Test-Path $Path) ) {
	throw "$Path does not exist"
}
if( $MaximumFileSize -le $MinimumFileSize ) {
	throw "MaximumFileSize must be larger than MinimumFileSize"
}
$totalKb = (($MaximumFileSize - (($MaximumFileSize - $MinimumFileSize) / 2)) * $NumberOfFiles)
$answer = Read-Host "You are about to create $NumberOfFiles in $Path which will take up approximately $totalKb KB. Do you want to proceed? [N/y]"
if( $answer -ne 'y' ) {
	exit
}
Write-Output "Generating random files"
$currentSub = Get-Item -Path $Path
$modulus = ($MaximumFileSize - $MinimumFileSize)
$buffer = [System.Array]::CreateInstance( [byte], 1024 )
$random = New-Object -TypeName "System.Random"
$random.NextBytes( $buffer )
$counter = 0
1..$NumberOfFiles | % {
	$name = [System.Guid]::NewGuid().ToString()
	$kb = (($random.Next() % $modulus) + $MinimumFileSize)
	if( $RandomSubFolders ) {
		$newSub = (($random.Next() % 174) -eq 0)
		if( $newSub ) {
			$subFolder = ([System.Guid]::NewGuid().ToString()) 
			$currentSub = New-Item -ItemType "directory" -Path $Path -Name $subFolder
		}
	}
	$newFile = New-Item -ItemType "file" -Path $currentSub -Name "$name.bin"
	Write-Progress -Activity "Generating files" -Status "$($newFile.Name) : $counter of $NumberOfFiles " -PercentComplete (($counter / $NumberOfFiles) * 99.9)
	$stream = $newFile.OpenWrite()
	1..$kb | % {
		$stream.Write( $buffer, 0, $buffer.Length )
	}
	$stream.Dispose()
	$counter++
}
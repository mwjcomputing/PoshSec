function Compare-Baseline {
	param(
		[Parameter(Mandatory=$true,Position=0)]
		[string]$BaselinePath,
		[Parameter(Mandatory=$true,Position=1)]
		[string]$ComparePath
		
	)

	$local:object = Compare-Object -ReferenceObject $BaselinePath -DifferenceObject $ComparePath -CaseSensitive
	
	$local:object

}
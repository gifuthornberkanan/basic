Function Get-ContinuedFraction () {

	param(
		[switch]$Debug,

		[string]$Presets,

		[string[]]$Sequence
	)
	Switch ($Presets) {
		"e"{
			$intparts=@(2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1, 10, 1, 1, 12, 1, 1, 14, 1, 1, 16, 1)
		}
		"pi" {
			$intparts=@(3, 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2, 1, 84)
		}
		"phi" {
			$intparts=@(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
		}
		"root2" {
			$intparts=@(1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2)
		}
		"root3" {
			$intparts=@(1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2)
		}
		#"" {
		#	$intparts=@()
		#}
		default {
			$Sequence=$($Sequence -replace ";",",")
			$intparts=@($Sequence -split ",")
		}
	}

	[array]::Reverse($intparts)
	$eks=1
	if ($Debug) {write-host $eks}
	foreach ($intgr in $intparts) {
		$intgr = $intgr -as [int]
		$eks=$($intgr+(1/($eks)))
		if ($Debug) {write-host "eks is   $eks"; write-host "intgr is $intgr"}
	}
	write-host $eks
}
Set-Alias cont Get-ContinuedFraction
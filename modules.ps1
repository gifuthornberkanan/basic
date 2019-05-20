function Get-AllHomeModules () {
	param(
		[Parameter(ParameterSetName='Import')]
		[switch]$Import,

		[Parameter(ParameterSetName='Reset')]
		[switch]$Reset
	)

	$pathe = "$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules"
	$filuz = @(Get-ChildItem -Path $pathe -Filter *.psm1 -Recurse -File -Name)

	$filuz | ForEach-Object {
		if ($Reset) {
			Remove-Module $_
		}
		Import-Module $_
	}
}
Set-Alias uptospeed Get-AllHomeModules
function Reset-Module () {
	$pathe = "$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules"
	$Module = $(Get-ChildItem -Path $pathe -Filter "$($args)`.psm1" -Recurse -File -Name)
	if ($(Get-Module -ListAvailable -Name $Module)) {
		Remove-Module -Name "$($args)" -Force -Verbose
	}
	Import-Module -Name $Module -Force -Verbose
	Write-Host "`n$($tag.Verbose)The module `'$($args)`' has been reset."
}
Set-Alias reset Reset-Module
function prompt {
	#$DateStampVar = $(Get-Date -Format "ddd dd-MMM-yyyy HH:mm:ss.ffff")
	$DtStmpDay = $(Get-Date -Format "ddd")
	$DtStmpDoM = $(Get-Date -Format "dd")
	$DtStmpMon = $(Get-Date -Format "MMM")
	$DtStmpYear = $(Get-Date -Format "yyyy")
	$DtStmpHour = $(Get-Date -Format "HH")
	$DtStmpMins = $(Get-Date -Format "mm")
	$DtStmpSecs = $(Get-Date -Format "ss")
	$DtStmpMils = $(Get-Date -Format "ffff")
	
	$PageBreakChar = "-"
	$HostName = $Env:ComputerName
	$HostName = $HostName.ToLower()
	$PSVer = $Host.Version.Major.ToString() + "." + $Host.Version.Minor.ToString()
	Write-Host $($PageBreakChar * 87) -NoNewLine
	Write-Host "$FG$($color.xVlet.xterm)$DtStmpDay" -NoNewLine
	Write-Host " $FG$($color.xMprp.xterm)$DtStmpDoM" -NoNewLine
	Write-Host "-$FG$($color.xMprp.xterm)$DtStmpMon" -NoNewLine
	Write-Host "-$FG$($color.xMprp.xterm)$DtStmpYear" -NoNewLine
	Write-Host " $FG$($color.xPrpl.xterm)$DtStmpHour" -NoNewLine
	Write-Host ":$FG$($color.xPrpl.xterm)$DtStmpMins" -NoNewLine
	Write-Host ":$FG$($color.xPrpl.xterm)$DtStmpSecs" -NoNewLine
	Write-Host ".$FG$($color.xPrpl.xterm)$DtStmpMils" -NoNewLine
	Write-Host $($PageBreakChar * 6)
	Write-Host "$FG$($color.xMppl.xterm)[PS v$PSVer] " -NoNewLine
	Write-Host "$FG$($color.xBloo.xterm)$Env:userdomain" -NoNewLine
	Write-Host "$FG$($color.xBloo.xterm)\" -NoNewLine
	Write-Host "$FG$($color.xGrin.xterm)$Env:username" -NoNewLine
	Write-Host "$FG$($color.xWite.xterm)@" -NoNewLine
	Write-Host "$FG$($color.xOrnj.xterm)$HostName" -NoNewLine
	Write-Host "$FG$($color.xRedd.xterm) in folder:" -NoNewLine
	Write-Host "$FG$($color.xYelo.xterm) $PWD "
	"> " #Final line can't be a Write-Host or PowerShell will add "PS>" by default
}

if (([Security.Principal.WindowsPrincipal] ` [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $role = "ADMINISTRATOR"
}
else {
    $role = "Standard User"
}
$host.ui.RawUI.WindowTitle = "PS user $ENV:USERNAME is running as $role"

# Dot sources the file where all my color variables are defined.
. C:\Users\<USER>\Documents\WindowsPowerShell\Scripts\color_defs.ps1

$host.PrivateData.ErrorForegroundColor = 'White'
$host.PrivateData.ErrorBackgroundColor = 'DarkRed'
$host.PrivateData.VerboseForegroundColor = 'Magenta'

Set-PSReadLineOption -Colors @{
	Command = "$FG$($color.Red)"
	Comment = "$FG$($color.Canvas)"
	ContinuationPrompt = "$FG$($color.xMprp.xterm)"
	DefaultToken = "$FG$($color.xWite.xterm)"
	Emphasis = "$($tag.HiLite)"
	Error = "Black"
	Keyword = "$FG$($color.OrangeJulius)"
	Member = "$FG$($color.ButterScotch)"
	Number = "$FG$($color.Grey)"
	Operator = "$FG$($color.CandyRed)"
	Parameter = "$FG$($color.Azure)"
	Selection = "$BG$($color.PSBlue)"
	String = "$FG$($color.Poppy)"
	Type = "$FG$($color.Azure)"
	Variable = "$FG$($color.LimeGreen)"
}

<#
function Show-Colors( ) {
  $($Colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($($Colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $($Color in $($Colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$($Color,$($Color) -NoNewline
    Write-Host "$Color" -Foreground $($Color
  }
}
#>

function Import-AllHomeModules () {
	$pathe = "C:\Users\<USER>\Documents\WindowsPowerShell\Modules"
	$filuz = @(Get-ChildItem -Path $pathe -Filter *.psm1 -Recurse -File -Name)
	$filuz | ForEach-Object {Import-Module $_}
}
Set-Alias uptospeed Import-AllHomeModules

function Edit-ProfileFile {
	Start-Process code $profile.AllUsersAllHosts
}
Set-Alias vimbash Edit-ProfileFile

function Reset-ProfileFile {
	. $profile.AllUsersAllHosts
}
Set-Alias renewal Reset-ProfileFile
Set-Alias tryagain Reset-ProfileFile
Set-Alias samsara Reset-ProfileFile

function Reset-Module () {
	$Module=$args
	if (Get-Module $Module) {
		Remove-Module $Module
	}
	Import-Module $Module
	Write-Host "The module '" $Module "' has been reset."
}
Set-Alias reset Reset-Module

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
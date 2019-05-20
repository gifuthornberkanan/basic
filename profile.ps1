if (([Security.Principal.WindowsPrincipal] ` [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$Role = "ADMINISTRATOR"
	$ImportAllModules = Read-Host -Prompt "Would you like to import all Modules?"
}
else {
	$Role = "STANDARD USER"
	$ImportAllModules = "y"
}
$host.ui.RawUI.WindowTitle = "$(Get-Date -Format "ddd, dd MMM yyyy") < $ENV:USERNAME > is running as $Role"

function prompt {
	$leftArrow = [char]0xe0b0
	$riteArrow = [char]0xe0b2
	$reset = $Clir
	$color0 = $color.Charcoal
	$color1 = $color.CandyRed
	$color2 = $color.Green
	$color3 = $color.OrangeJulius
	$color4 = $color.SkyBlue
	$color5 = $color.Slet
	$color6 = $color.Canvas
	
	$arrow1 = "$FG$color1$BG$color2$leftArrow$reset"
	$arrow2 = "$FG$color2$BG$color3$leftArrow$reset"
	$arrow3 = "$FG$color3$BG$color0$leftArrow$reset"
	$arrow4 = "$FG$color4$BG$color0$riteArrow$reset"
	$arrow5 = "$FG$color5$BG$color4$riteArrow$reset"
	$arrow6 = "$FG$color6$BG$color5$riteArrow$reset"

	if ($MyInvocation.HistoryId -eq 1) {
		$CmdDuration 	= "00:00.0000"
	}
	else {
		$CmdDuration 	= (Get-History)[-1].EndExecutionTime - (Get-History)[-1].StartExecutionTime
		$CmdDuration 	= $CmdDuration.ToString().Substring(3,10)
	}
	$CommandDur 		= "$BG$color4$FG$color0$CmdDuration $reset"

	$YearForm 			= $(Get-Date -Format "yyyyMMdd")
	$YearStamp 			= "$BG$color5$FG$color0$YearForm $reset"

	$DateForm 			= $(Get-Date -Format "HH:mm:ss.ffff")
	$DateStamp 			= "$BG$color6$FG$color0$DateForm $reset"
	
	$History 				= "$BG$color1$FG$color0 $('{0:d4}' -f $MyInvocation.HistoryId)$reset"
	$PSVersion 			= "$BG$color2$FG$($color0)PS_$($Host.Version.Major.ToString()).$($Host.Version.Minor.ToString())$reset"
	$Directory 			= "$BG$color3$FG$color0 $(Split-Path $pwd.ToString() -Leaf)$reset"

	if ($ENV:UserName -eq $(Split-Path $pwd.ToString() -Leaf)) {
			$Directory 	= "$BG$color3$FG$color0 ~$reset"
	}

	$leftSide 			= "$History$arrow1$PSVersion$arrow2$Directory$arrow3"
	$offset 				= $($Host.UI.RawUI.BufferSize.Width - 37)
	$rightSide 			= "$arrow4$CommandDur$arrow5$YearStamp$arrow6$DateStamp"

	$promptOut 			= -join $leftSide, "$([char]27)[${offset}G", $rightSide
	
	Write-Host $promptOut
"> " #Final line can't be a Write-Host or PowerShell will add "PS>" by default
#Remove-Variable prompt
}
<#
function OLDprompt {
	#$DateStampVar = $(Get-Date -Format "ddd dd-MMM-yyyy HH:mm:ss.ffff")
	$ddd = "$FG$($color.Vlet)$(Get-Date -Format "ddd")$($Clir)"
	$dd = "$FG$($color.Mprp)$(Get-Date -Format "dd")$($Clir)"
	$MMM = "$FG$($color.Mprp)$(Get-Date -Format "MMM")$($Clir)"
	$yyyy = "$FG$($color.Mprp)$(Get-Date -Format "yyyy")$($Clir)"
	$HH = "$FG$($color.Prpl)$(Get-Date -Format "HH")$($Clir)"
	$mm = "$FG$($color.Prpl)$(Get-Date -Format "mm")$($Clir)"
	$ss = "$FG$($color.Prpl)$(Get-Date -Format "ss")$($Clir)"
  $ffff = "$FG$($color.Prpl)$(Get-Date -Format "ffff")$($Clir)"
	$DateStamp = "$ddd $dd-$MMM-$yyyy $HH`:$mm`:$ss.$ffff"
	$prompt = [PSCustomObject]@{
        PageBreakChar = "-"
        PSVer = "$FG$($color.Mppl)[PS v$($Host.Version.Major.ToString()).$($Host.Version.Minor.ToString())]$($Clir)"
        Domain = "$FG$($color.Bloo)$($ENV:UserDomain)\$($Clir)"
        User = "$FG$($color.Grin)$($ENV:UserName)$($Clir)"
        At = "$FG$($color.Wite)@$($Clir)"
        HostName = "$FG$($color.Ornj)$($($ENV:ComputerName).ToLower())$($Clir)"
        Directrix = "$FG$($color.Redd)in directory:$($Clir)"
        Directory = "$FG$($color.Yelo)$($PWD) $($Clir)"
    }

	Write-Host "$($prompt.PageBreakChar * 77) $DateStamp $($prompt.PageBreakChar * 6)" #77+1+29+1+6+6=120
	Write-Host "$($prompt.PSVer) $($prompt.Domain)$($prompt.User)$($prompt.At)$($prompt.HostName) $($prompt.Directrix) $($prompt.Directory)"
	"> " #Final line can't be a Write-Host or PowerShell will add "PS>" by default
	Remove-Variable prompt
}
#>

$FgFG = ""
$FgFG.Trim()
$BgBG = ""
$BgBG.Trim()

# Dot sources the file where all my color variables are defined.
. "$ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\color_defs.ps1"
. "$ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\xterm_defs.ps1"

# Dot sources the file where my module manipulation functions live.
. "$ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\modules.ps1"

if ($ImportAllModules -eq "y") {Get-AllHomeModules -Import; Remove-Variable ImportAllModules}
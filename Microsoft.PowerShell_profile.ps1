function prompt {
	$DateStamp1 = $(Get-Date -Format "ddd")
	$DateStamp2 = $(Get-Date -Format "dd-MMM-yyyy")
	$DateStamp3 = $(Get-Date -Format "HH:mm:ss.ffff")
	$Colour = [char]27
	$HostName = $Env:ComputerName
	$HostName = $HostName.ToLower()
	$PSVer = $Host.Version.Major.ToString() + "." + $Host.Version.Minor.ToString()
	Write-Host "-------------------------------------------------------------------------------" -NoNewLine
	Write-Host "$Colour[38;5;92m$DateStamp1 " -NoNewLine
	Write-Host "$Colour[38;5;141m$DateStamp2 " -NoNewLine
	Write-Host "$Colour[38;5;129m$DateStamp3" -NoNewLine
	Write-Host "------"
	Write-Host "$Colour[38;5;135m[PS v$PSVer] " -NoNewLine
	Write-Host "$Colour[38;5;40m$Env:username"  -NoNewLine
	Write-Host "$Colour[38;2;255;255;255m@" -NoNewLine
	Write-Host "$Colour[38;5;33m$HostName " -NoNewLine
	Write-Host "$Colour[38;5;124min directory: " -NoNewLine
	Write-Host "$Colour[38;5;178m$PWD"
	"> " #Final line can't be a Write-Host or PowerShell will add "PS>" by default
	#$host.ui.rawui.WindowTitle = ?Windows PowerShell in directory: ? + $(Get-Location)
}
#$host.PrivateData.ErrorForegroundColor = 'White'


function Edit-ProfileFile{
	Notepad $profile
}
Set-Alias vimbash Edit-ProfileFile

function Reload-ProfileFile{
	.$profile
}
Set-Alias renewal Reload-ProfileFile
Set-Alias tryagain Reload-ProfileFile
Set-Alias samsara Reload-ProfileFile

function Convert-MACAddress($mAdr, $mIpt) {
	#Step 1: convert MAC-48 address to lowercase since this is default.
	$mAdr="$mAdr".ToLower()
	#Step 2: remove anything in the variable that is not a hexidecimal digit.
	$mAdr=$mAdr -replace '[^A-Fa-f0-9]'
	#Step 3: insert underscores as a dummy separator between each octet.
	$mAdr=([regex]::matches($mAdr, '.{1,2}') | %{$_.value}) -join '_'
	#Step 4: put each octet into its own variable.
	$f1="$mAdr".Substring(0,2)
	$f2="$mAdr".Substring(3,2)
	$f3="$mAdr".Substring(6,2)
	$f4="$mAdr".Substring(9,2)
	$f5="$mAdr".Substring(12,2)
	$f6="$mAdr".Substring(15,2)
	$ts=""
	$fs=""
	$mSgn=""
	# Step 5: set variable with allowable switches.
	$mRgx = @('-','c','d','h','l','s','u','2','4','0')
	$mRrf = [string]::Join('|', [Regex]::Escape($mRgx))
	# Step 6: convert human readable inputs to script readable inputs.
	If ("$mIpt".Contains("windows")) {$mIpt="-2hu"}
	If ("$mIpt".Contains("linux")) {$mIpt="-2c"}
	If ("$mIpt".Contains("cisco")) {$mIpt="-4d"}
	If ("$mIpt".Contains("infoblox")) {$mIpt="-2c"}
	If ("$mIpt".Contains("ise")) {$mIpt="-2cl"}
	If ("$mIpt".Contains("ios")) {$mIpt="-4dl"}
	# Step 7: if the "-a" switch is used, then display all possible variants.
	##If ("$mIpt".Contains("-a")) {}
	# Step 8: test for allowable switches. if letters are used other than the relevant ones, then give an error.
	##ElseIf ("$mIpt" -match $mRrf) {
	# Step 9a: set the separator sign.
	If ("$mIpt" -match "h") {$mSgn="-"}
	ElseIf ("$mIpt" -match "d") {$mSgn="."}
	ElseIf ("$mIpt" -match "c") {$mSgn=":"}
	ElseIf ("$mIpt" -match "s") {$mSgn=" "}
	# Step 9b: set the grouping size.
	If ("$mIpt" -match "2") {$ts=$mSgn; $fs=$mSgn}
	ElseIf ("$mIpt" -match "4") {$fs=$mSgn}
	ElseIf ("$mIpt" -match "0") {}
	# Step 9c: set full address or last 4.
	If ("$mIpt" -match "l") {$mOut="$f5$ts$f6"}
	Else {$mOut="$f1$ts$f2$fs$f3$ts$f4$fs$f5$ts$f6"}
	# Step 9d: make uppercase if "-u" switch is used.
	If ("$mIpt" -match "u") {$mOut="$mOut".ToUpper()}
	# Step 10: send final output to the clipboard and display a message.
	##}
	echo "$mOut" | Set-Clipboard
	echo "$mOut has been copied to the clipboard."
	##Else {} # <- This is where the error message gets placed.
	# Step 3b: send final output to log file.
	$mYear = Get-Date -UFormat %d-%b-%Y
	$mDate = Get-Date -UFormat %H:%M:%S
}
Set-Alias cpmac Convert-MACAddress

function Test-Switches {
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$MAC,

		[Parameter(ParameterSetName='Granular')]
		[ValidateSet(0, 2, 4)]
		[int]$GroupSize,

		[Parameter(ParameterSetName='Granular')]
		[ValidateSet("-", ":", ".", " ")]
		[string]$Separator,

		[Parameter(ParameterSetName='Granular')]
		[switch]$UpperCase,

		[Parameter(ParameterSetName='Granular')]
		[switch]$LastFour,

		[Parameter(ParameterSetName='HumanReadable')]
		[switch]$Cisco,

		[Parameter(ParameterSetName='HumanReadable')]
		[Alias("Infoblox")]
		[switch]$Linux,

		[Parameter(ParameterSetName='HumanReadable')]
		[Alias("Win")]
		[switch]$Windows,

		[Parameter(ParameterSetName='HumanReadable')]
		[switch]$ISE,

		[Parameter(ParameterSetName='HumanReadable')]
		[switch]$IOS
	)
	
	if ($Cisco) {
		$GroupSize=4
		$Separator="."
	}
	if ($Linux) {
		$GroupSize=2
		$Separator=":"
	}
	if ($Windows) {
		$GroupSize=2
		$Separator="-"
		$UpperCase=$true
	}
	if ($ISE) {
		$GroupSize=2
		$Separator=":"
		$LastFour=$true
	}
	if ($IOS) {
		$GroupSize=4
		$LastFour=$true
	}
	
	$mAdr="$MAC".ToLower()
	
	$mAdr=$mAdr -replace '[^A-Fa-f0-9]'
	
	#$mAdr=([regex]::matches($mAdr, '.{1,2}') | %{$_.value}) -join '_'
	
	$f1="$mAdr".Substring(0,2)
	$f2="$mAdr".Substring(3,2)
	$f3="$mAdr".Substring(4,2)
	$f4="$mAdr".Substring(6,2)
	$f5="$mAdr".Substring(8,2)
	$f6="$mAdr".Substring(10,2)
	$ts=""
	$fs=""
	$mSgn=$Separator

	If ($GroupSize -eq 0) {}
	ElseIf ($GroupSize -eq 2) {$ts=$mSgn; $fs=$mSgn}
	ElseIf ($GroupSize -eq 4) {$fs=$mSgn}
	
	If ($LastFour) {$mOut="$f5$ts$f6"}
	Else {$mOut="$f1$ts$f2$fs$f3$ts$f4$fs$f5$ts$f6"}

	If ($UpperCase) {$mOut="$mOut".ToUpper()}
	
	echo "$mOut" | Set-Clipboard
	Write-Host "$mOut has been copied to the clipboard."
}
Set-Alias tssw Test-Switches
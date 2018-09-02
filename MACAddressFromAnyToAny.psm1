$Colour = [char]27
$BGWhite = "[48;2;255;255;255m"
$FGBlue = "[38;2;1;36;86m"
$ResultTag = "$Colour$BGWhite$Colour$FGBlue"
$Cliyr = "[00m"
$EndResultTag = "$Colour$Cliyr"
function Format-MACAddressFromAnyToAny {
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

		[Parameter(ParameterSetName='Cisco')]
		[switch]$Cisco,

		[Parameter(ParameterSetName='Linux')]
        [Alias("Infoblox")]
        [Alias("OSX")]
        [Alias("macOS")]
		[switch]$Linux,

		[Parameter(ParameterSetName='Windows')]
		[Alias("Win")]
		[switch]$Windows,

		[Parameter(ParameterSetName='ISE')]
		[switch]$ISE,

		[Parameter(ParameterSetName='IOS')]
		[switch]$IOS
	)

    Switch ($PSCmdlet.ParameterSetName) {
	    "Cisco" {
		    $GroupSize=4
		    $Separator="."
	    }
	    "Linux" {
		    $GroupSize=2
		    $Separator=":"
	    }
	    "Windows" {
		    $GroupSize=2
		    $Separator="-"
		    $UpperCase=$true
	    }
	    "ISE" {
		    $GroupSize=2
		    $Separator=":"
		    $LastFour=$true
	    }
	    "IOS" {
		    $GroupSize=4
		    $LastFour=$true
        }
    }
    
    # Force lower case by default.
    $MACAddress="$MAC".ToLower()
    
    # Remove any characters that are not Hexadecimal digits.
    $MACAddress=$MACAddress -replace '[^A-Fa-f0-9]'
    
    # If the LastFour switch is used, truncate the string to the last 4 digits.
    if ($LastFour) {$MACAddress=$MACAddress.Substring($MACAddress.get_Length()-4)}
    
    # For group sizes of 2 and 4, insert the preferred separator at the desired interval.
	if ($GroupSize -gt 0) {$MACAddress=([regex]::matches($MACAddress, ".{1,$GroupSize}") | ForEach-Object{$_.value}) -join "$Separator"}

    # If the UpperCase switch is used, convert the string to upper case.
	If ($UpperCase) {
		$MACAddress="$MACAddress".ToUpper()
	}
    
    # Send final formatted MAC address to the clipboard for use elsewhere. Also put message on CLI.
	Set-Clipboard -Value "$MACAddress"
    Write-Host "$ResultTag $MACAddress $EndResultTag has been copied to the clipboard."
    
    # Format a hash table with timestamp, name of function and all variables used and their states.
	$DateStamp=$(Get-Date -Format "yyyy-MM-dd_HH:mm:ss.ffff")
	$ThisFunc=$MyInvocation.MyCommand
	$LogOutput=@(
		"$DateStamp"
		"    The function '$ThisFunc' ran with the following results:"
		"    User:                  $ENV:USERNAME"
		"    Input MAC Address:     $MAC"
		"    Output MAC Address:    $MACAddress"
		"    Group sizing:          $GroupSize"
		"    Preferred separator:   '$Separator'"
		"    Upper case:            $UpperCase"
		"    Only last four digits: $LastFour"
    )

    # Set variable with path to log file in the same folder as this module.
    $CurDir=$PSScriptRoot + "\maclog.mlog"

    # If the log file does not already exist, create it.
    If (!(Test-Path -Path $CurDir)) {
        New-Item -Path $PSScriptRoot -Name maclog.mlog -ItemType "file"
    }

    # Ouput to log file.
	Out-File -InputObject $LogOutput -LiteralPath $CurDir -Append -Encoding "unicode"
}
Set-Alias fmac Format-MACAddressFromAnyToAny
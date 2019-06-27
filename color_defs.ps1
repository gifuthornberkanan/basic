#--- Color Definitions File ---


#--- Formatting stuff ---

# 2 * 10^1 + 7 * 10^0 = 1 * 16^1 + 11*16^0 :: dec 27 = hex 1b
$global:BG              = "$([char]27)[48;"     # introduces background color changes
$global:FG              = "$([char]27)[38;"     # introduces foreground color changes
$global:Clir            = "$([char]0x1b)[00m"   # ends a color sequence

#--- Create Color Objects ---

$primaries              = @("Reds","Greens","Blues","Achromatic")
$secondaries            = @("Reds","Yellows","Greens","Cyans","Blues","Magentas","Achromatic")
$tertiaries             = @("Reds","Oranges","Yellows","Limes","Greens","Teals","Cyans",
                            "Azures","Blues","Purples","Magentas","Pinks","Achromatic")


#--- Custom Combos ---
$global:tag = @{
    Result              = "$FG$( $xterm.PSBlue.tbit   )$BG$( $xterm.White.tbit    )"
    HiLite              = "$FG$( $xterm.Charcoal.tbit )$BG$( $xterm.GoldDeep.tbit )"
    Verbose             = "$FG$( $xterm.Yellow.tbit   )$BG$( $xterm.Charcoal.tbit )"
}

#$host.PrivateData.ErrorForegroundColor     = 'White'
$host.PrivateData.ErrorBackgroundColor      = 'DarkMagenta'
#$host.PrivateData.VerboseForegroundColor   = 'Magenta'

Set-PSReadLineOption -Colors @{
	Command             = "$FG$($xterm.Red.tbit)"
	Comment             = "$FG$($xterm.Gray.tbit)"
	ContinuationPrompt  = "$FG$($xterm.Lavendar.tbit)"
	DefaultToken        = "$FG$($xterm.Roseine.tbit)"
	Emphasis            =    "$($tag.HiLite)"
	Error               = "$FG$($xterm.Golden.tbit)"
	Keyword             = "$FG$($xterm.OrangeJulius.tbit)"
	Member              = "$FG$($xterm.ButterScotch.tbit)"
	Number              = "$FG$($xterm.Violet.tbit)"
	Operator            = "$FG$($xterm.CandyRed.tbit)"
	Parameter           = "$FG$($xterm.Azure.tbit)"
	Selection           = "$BG$($xterm.PSBlue.tbit)"
	String              = "$FG$($xterm.Marigold.tbit)"
	Type                = "$FG$($xterm.RobinsEgg.tbit)"
	Variable            = "$FG$($xterm.LimeGreen.tbit)"
} -ContinuationPrompt "-"

# Functions for displaying colors

function Get-ColorSwatches () {
    param(
        [ValidateRange( 1,6 )]
        [int] $Columns = 4,

        [int] $Padding = 21,

        [ValidateRange( 1,9 )]
        [decimal] $Size = 3,

        [Parameter(ParameterSetName = 'Family' )]
        [string]$Family,

        [Parameter(ParameterSetName = 'Family' )]
        [string]$Level,

        [Parameter(ParameterSetName = 'Names' )]
        [string[]]$Set
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Family" {
            $xterm.Keys | ForEach-Object {
                if ($Family -eq $xterm.$_.$Level) {
                    $ColorNameArray += @($_)
                }
            }
        }
        "Names"  {
            $ColorNameArray = $Set
        }
    }

    $ColorNameArray | ForEach-Object {
        $Counter += 1

        $colorBit = $xterm.$_.tbit

        $line1 += "$BG$colorBit$(" " * ($Size * 2))$Clir " + "$_".PadRight( $Padding, " " )
        $line2 += "$BG$colorBit$(" " * ($Size * 2))$Clir " + "  ".PadRight( $Padding, " " )

        if ( ( ( $Counter % $Columns ) -eq 0 ) -or ( $Counter -eq $ColorNameArray.Count ) ) {
            foreach ( $i in 1..$Size ) {
                if ( $i -eq ([math]::Round( ( $Size + 0.5 ) / 2) ) ) { Write-Host $line1 } else { Write-Host $line2 }
            }
        }

        if ( ( $Counter % $Columns ) -eq 0 ) { $line1 = ""; $line2 = "" }
    }

    $line1 = ""; $line2 = ""; $Counter = 0
}

function Get-ColorCards {
    param(
        [Parameter(ParameterSetName = 'Family' )]
        [string]$Family,

        [Parameter(ParameterSetName = 'Family' )]
        [string]$Level,

        [Parameter(ParameterSetName = 'Names' )]
        [string[]]$Set
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Family" {
            $xterm.Keys | ForEach-Object {
                if ($Family -eq $xterm.$_.$Level) {
                    $ColorNameArray += @($_)
                }
            }
        }
        "Names"  {
            $ColorNameArray = $Set
        }
    }

    $ColorNameArray | ForEach-Object {
        $Counter += 1

        $colorBit = $xterm.$_.tbit

        $line1 += "$_$BG$colorBit$(" " * (20 - "$_".Length) )$Clir"
        $line2 += "$($xterm.$_.hexString)$BG$colorBit$(" " * 13)$Clir"
        $line3 += "$BG$colorBit$(" " * 20)$Clir"

        if ( ( ( $Counter % 6 ) -eq 0 ) -or ( $Counter -eq $ColorNameArray.Count ) ) {
            Write-Host $line1
            Write-Host $line2
            foreach ( $i in 3..6 ) {
                Write-Host $line3
            }
        }

        if ( ( $Counter % 6 ) -eq 0 ) { $line1 = ""; $line2 = ""; $line3 = "" }
    }

    $line1 = ""; $line2 = ""; $line3 = ""; $Counter = 0
}

# Functions for setting color themes
function Set-ColorThemeValues () {
    param(
        [string]$NewColor,
        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Text' )]
        [ValidateRange( 1,6 )]
        [int]$Text,
        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Back' )]
        [ValidateRange( 1,6 )]
        [int]$Back
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Back" { $ThemeNum = $Back; $Theme = "a"; $Number = $Back + 10 }
        "Text" { $ThemeNum = $Text; $Theme = "b"; $Number = $Text + 20 }
    }

    $file = Get-Content -Path C:\Users\InTerraPax\Documents\WindowsPowerShell\Scripts\color_themes.ps1

    $file[$Number] = "`$theme$ThemeNum$Theme = `$xterm.$NewColor.tbit"

    $file | Set-Content -Path C:\Users\InTerraPax\Documents\WindowsPowerShell\Scripts\color_themes.ps1

}

function Set-ColorTheme () {
    param(
        [string]$Theme
    )

    . "C:\Users\InTerraPax\Documents\WindowsPowerShell\Scripts\$Theme.ps1"

    $PSColorTheme | ForEach-Object {
        $Themelet = $_
        Set-ColorThemeValues @Themelet
    }
}

function Convert-RGBToHSL
{
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Red,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Green,
        [Parameter(Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Blue
    )
    process
    {
        $arry = @(($red / 255), ($green / 255), ($blue / 255))
        $max = 0
        $min = 0
        for($i = 1; $i -lt $arry.Length; $i++)
        {
            if($arry[$i] -gt $arry[$max])
            {
                $max = $i
            }

            if($arry[$i] -lt $arry[$min])
            {
                $min = $i
            }
        }
        $C = $arry[$max] - $arry[$min]
        $hue = 0
        $lightness = 0
        if(0 -ne $C)
        {
            $hue = ($arry[($max + 4) % 3] - $arry[($max+5) % 3]) / $C

            if(0 -eq $max)
            {
                $hue %= 6
            }
            else
            {
                $hue += 2*$max
            }

            $hue *= 60
            if ($hue -lt 0) {$hue = $hue + 360}
            $lightness = 0.5 * ($arry[$min] + $arry[$max])
            $saturation = $C / (1 - [Math]::Abs(2.0 * $lightness - 1)) * 100
            $lightness *= 100
        }
        return [pscustomobject]@{hue = $( "{0:N2}" -f $hue); saturation = $( "{0:N2}" -f $saturation); lightness = $( "{0:N2}" -f $lightness)} | Format-List
    }
}

function Get-ClosestXTermColor () {
    $HexString = $args

    $r = "0x$($HexString.Substring(1,2))"
    $g = "0x$($HexString.Substring(3,2))"
    $b = "0x$($HexString.Substring(5,2))"

    $rx = [int32]$r
    $gx = [int32]$g
    $bx = [int32]$b

    $rx = $rx - 15
    $rx = $rx / 40
    $rx = [math]::Round($rx)
    $rx *= 40
    $rx += 15
    if ($rx -eq 15) {$rx = 0}
    if ($rx -eq 55) {$rx = 95}
    
    $gx = $gx - 15
    $gx = $gx / 40
    $gx = [math]::Round($gx)
    $gx *= 40
    $gx += 15
    if ($gx -eq 15) {$gx = 0}
    if ($gx -eq 55) {$gx = 95}

    $bx = $bx - 15
    $bx = $bx / 40
    $bx = [math]::Round($bx)
    $bx *= 40
    $bx += 15
    if ($bx -eq 15) {$bx = 0}
    if ($bx -eq 55) {$bx = 95}

    $rgbString = "rgb($rx,$gx,$bx)"

    $xterm.Keys | ForEach-Object {
        if ($xterm.$_.rgbString -eq $rgbString) {Write-Host "$_`:".PadRight(24," ")$xterm.$_.hexString}
    }
}
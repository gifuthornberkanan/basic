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

        [string]$Family,

        [string]$Level
    )

    $xterm.Keys | ForEach-Object {
        if ($Family -eq $xterm.$_.$Level) {
            $ColorNameArray += @($_)
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
        [string]$Family,

        [string]$Level
    )

    $xterm.Keys | ForEach-Object {
        if ($Family -eq $xterm.$_.$Level) {
            $ColorNameArray += @($_)
        }
    }

    $ColorNameArray | ForEach-Object {
        $Counter += 1

        $colorBit = $xterm.$_.tbit

        $line1 += "$_$BG$colorBit$(" " * (20 - "$_".Length) )$Clir"
        $line2 += "$BG$colorBit$(" " * 20)$Clir"

        if ( ( ( $Counter % 6 ) -eq 0 ) -or ( $Counter -eq $ColorNameArray.Count ) ) {
            Write-Host $line1
            foreach ( $i in 2..6 ) {
                Write-Host $line2
            }
        }

        if ( ( $Counter % 6 ) -eq 0 ) { $line1 = ""; $line2 = "" }
    }

    $line1 = ""; $line2 = ""; $Counter = 0
    
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
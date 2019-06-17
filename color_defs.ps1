#--- Color Definitions File ---


#--- Formatting stuff ---

# 2 * 10^1 + 7 * 10^0 = 1 * 16^1 + 11*16^0 :: dec 27 = hex 1b
$global:BG              = "$([char]27)[48;"     # introduces background color changes
$global:FG              = "$([char]27)[38;"   # introduces foreground color changes
$global:Clir            = "$([char]0x1b)[00m"   # ends a color sequence

#--- Create Color Objects ---

$global:color = @{

    # Reds
    Red                 = "2;255;00;00m"        # colorID = 9, 196
    Maroon			    = "2;128;0;0m"          # colorID = 1
    RedDark             = '2;175;0;0m'          # colorID = 124, Redd
    CandyRed            = "2;255;44;75m"        # Taken from Badwolf color theme in Vim
    Salmon              = "2;250;128;114m"      # name taken by colorID 209, new name is TerraCotta
    Pink                = "2;255;182;193m"      # name taken by colorID 199, new name is CottonCandy
    Magenta             = "2;255;20;147m"       # name too similar to xterm names, new name is Roseine

    # Oranges
    Marigold            = "2;255;175;0m"        # Taken from Badwolf color theme in Vim, colorID = 214
    Apricot			    = "2;255;135;0m"        # colorID = 208
    Orange			    = "2;255;95;0m"         # colorID = 202
    OrangeDark          = '2;215;95;0m'         # colorID = 166, Ornj
    OrangeJulius        = "2;255;167;36m"       # Taken from Badwolf color theme in Vim
    Butterscotch        = "2;244;207;134m"      # Taken from Badwolf color theme in Vim

    # Yellows
    Yellow              = "2;255;255;0m"        # colorID = 11, 226
    Cream			    = "2;255;215;95m"       # colorId = 221
    GoldDeep            = '2;215;175;0m'        # colorID = 178, Yelo
    Brown               = "2;120;66;18m"
    Golden              = "2;241;196;15m"
    Caramel             = "2;186;74;0m"
    Tan                 = "2;210;180;140m"      # name taken by colorID 180, new name is Almond

    # Greens
    Khaki			    = "2;175;175;95m"       # colorID = 143
    Green               = "2;0;255;0m"          # colorID = 10, 46
    Pistachio		    = "2;175;255;175m"      # colorID = 157
    GreenDeep           = '2;0;215;0m'          # colorID = 40, Grin
    LimeGreen           = "2;174;238;0m"        # Taken from Badwolf color theme in Vim
    Algae               = "2;102;153;0m"
    SeaFoamGreen        = "2;118;215;196m"

    # Blues
    Blue                = "2;0;0;255m"          # colorID = 12, 21
    Cyan                = "2;0;255;255m"        # colorID = 14, 51
    DodgerBlueLight     = '2;0;135;255m'        # colorID = 33, Bloo
    Turquoise           = "2;64;224;208m"       # name taken by colorID 44, new name is RobinsEgg
    SkyBlue             = "2;135;206;250m"      # name taken by colorID 39, new name is BabyBlue
    Azure               = "2;10;157;255m"       # Taken from Badwolf color theme in Vim
    PSBlue              = "2;0;26;56m"          # Default PowerShell console window background color

    # Purples
	Lavendar		    = "2;175;135;255m"      # colorID = 141, Mprp (Tym2 before that)
    Purple              = "2;128;0;128m"        # colorID = 5
    Eggplant            = "2;95;0;95m"          # colorID = 53
    Violet			    = "2;175;95;255m"       # colorID = 135, Mppl (Prpl before that)
    Periwinkle		    = "2;215;175;255m"      # colorID = 183
    SlateBlueDeep       = '2;135;95;255m'       # colorID = 99, Slet
    PurpleDeep          = '2;135;0;215m'        # colorID = 92, Vlet (Tym1 before that)
    PurpleLight         = '2;175;0;255m'        # colorID = 129, Prpl (Tym3 before that)
    Orchid              = "2;218;112;214m"      # name taken by colorID 170, new name is Bougainvillea

    # Monochromes
    Silver              = "2;192;192;192m"      # colorID = 7
    Black               = "2;0;0;0m"            # colorID = 0, 16
    White               = "2;255;255;255m"      # colorID = 15, 231, Wite
    Charcoal            = "2;20;20;19m"         # my preferred console window background color
    Grey                = "2;153;143;132m"      # Taken from Badwolf color theme in Vim, name taken by colorID 8, new name is Gray
    Canvas              = "2;248;246;242m"      # Taken from Badwolf color theme in Vim
}

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

# Function for displaying colors

function Get-ColorSwatches () {
    param(
        [ValidateRange( 1,6 )]
        [int] $Columns,

        [int] $Padding,

        [ValidateRange( 1,9 )]
        [decimal] $Size = 3,

        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Color' )]
        [switch] $colors,

        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Xterm' )]
        [switch] $xterms
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Color" { $ColorNameArray = $color.Keys; if ( !$Columns ) { $Columns = 5 }; if ( !$Padding ) { $Padding = 16 } }
        "Xterm" { $ColorNameArray = $xterm.Keys; if ( !$Columns ) { $Columns = 4 }; if ( !$Padding ) { $Padding = 21 } }
    }

    $ColorNameArray | ForEach-Object {
        $Counter += 1

        if ( $xterms ) { $colorBit = $xterm.$_.tbit }
        if ( $colors ) { $colorBit = $color.$_ }

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
    param (
        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Color' )]
        [switch] $colors,

        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Xterm' )]
        [switch] $xterms
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Color" { $ColorNameArray = $color.Keys }
        "Xterm" { $ColorNameArray = $xterm.Keys }
    }

    $ColorNameArray | ForEach-Object {
        $Counter += 1

        if ( $xterms ) { $colorBit = $xterm.$_.tbit }
        if ( $colors ) { $colorBit = $color.$_      }

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
        "Text" { $ThemeNum = $Text; $Theme = "b"; $Number = $Text + 19 }
        "Back" { $ThemeNum = $Back; $Theme = "a"; $Number = $Back + 9  }
    }

    $file = Get-Content -Path C:\Users\InTerraPax\Documents\WindowsPowerShell\Scripts\color_themes.ps1

    $file[$Number] = "`$theme$ThemeNum$Theme = `$xterm.$NewColor.tbit"

    $file | Set-Content -Path C:\Users\InTerraPax\Documents\WindowsPowerShell\Scripts\color_themes.ps1

}
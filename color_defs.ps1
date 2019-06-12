#--- Color Definitions File ---


#--- Formatting stuff ---

#$global:Color     = $([char]27)            #Escape character
#$global:Colour    = $([char]0x1b)          #Escape character
$global:BG         = "$([char]27)[48;"      #introduces background color changes
$global:FG         = "$([char]0x1b)[38;"    #introduces foreground color changes
$global:Clir       = "$([char]0x1b)[00m"    #ends a color sequence

#--- Create Color Objects ---

$global:color = @{

    #--- xTerm256 color codes ---
    Redd           = '2;175;0;0m'           # xterm256 - 124
    Ornj           = '2;215;95;0m'          # xterm256 - 166
    Yelo           = '2;223;175;0m'         # xterm256 - 178
    Grin           = '2;0;215;0m'           # xterm256 - 40
    Bloo           = '2;0;135;255m'         # xterm256 - 33
    Mppl           = '2;175;95;255m'        # xterm256 - 135    #Prpl
    Wite           = '2;255;255;255m'       # xterm256 - 15
    Slet           = '2;135;95;255m'        # xterm256 - 99
    Vlet           = '2;135;0;215m'         # xterm256 - 92     #Tym1
    Mprp           = '2;175;135;255m'       # xterm256 - 114    #Tym2
    Prpl           = '2;175;0;255m'         # xterm256 - 129    #Tym3

    #--- RGB color codes ---

    # Reds
    Red             = "2;255;00;00m"        #Plain ol' red
    CandyRed        = "2;255;44;75m"        #Taken from Badwolf color theme in Vim
    Salmon          = "2;250;128;114m"
    Pink            = "2;255;182;193m"
    Magenta         = "2;255;20;147m"

    # Oranges
    OrangeJulius    = "2;255;167;36m"       #Taken from Badwolf color theme in Vim
    Butterscotch    = "2;244;207;134m"      #Taken from Badwolf color theme in Vim
    Poppy           = "2;255;175;0m"        #Taken from Badwolf color theme in Vim

    # Yellows
    Brown           = "2;120;66;18m"
    Golden          = "2;241;196;15m"
    Yellow          = "2;255;255;0m"
    Caramel         = "2;186;74;0m"
    Tan             = "2;210;180;140m"

    # Greens
    LimeGreen       = "2;174;238;0m"        #Taken from Badwolf color theme in Vim
    SeaFoamGreen    = "2;118;215;196m"
    Khaki           = "2;240;230;140m"
    Green           = "2;0;255;0m"
    Algae           = "2;102;153;0m"

    # Blues
    Blue            = "2;0;0;255m"
    Cyan            = "2;0;255;255m"
    Turquoise       = "2;64;224;208m"
    SkyBlue         = "2;135;206;250m"
    Azure           = "2;10;157;255m"       #Taken from Badwolf color theme in Vim
    PSBlue          = "2;0;26;56m"          #Default PowerShell console window background color

    # Purples
    Lavender        = "2;230;230;250m"
    Orchid          = "2;218;112;214m"
    Purple          = "2;128;0;128m"

    # Monochromes
    Silver          = "2;192;192;192m"
    Charcoal        = "2;20;20;19m"         #my preferred console window background color
    Grey            = "2;153;143;132m"      #Taken from Badwolf color theme in Vim
    Canvas          = "2;248;246;242m"      #Taken from Badwolf color theme in Vim
    Black           = "2;0;0;0m"
    White           = "2;255;255;255m"
}

#--- Custom Combos ---
$global:tag = @{
    Result = "$FG$($color.PSBlue)$BG$($color.Wite)"
    HiLite = "$FG$($color.Charcoal)$BG$($color.Yelo)"
    Verbose = "$FG$($color.Yellow)$BG$($color.Black)"
}

#$host.PrivateData.ErrorForegroundColor = 'White'
$host.PrivateData.ErrorBackgroundColor = 'DarkMagenta'
#$host.PrivateData.VerboseForegroundColor = 'Magenta'

Set-PSReadLineOption -Colors @{
	Command = "$FG$($color.Red)"
	Comment = "$FG$($color.Canvas)"
	ContinuationPrompt = "$FG$($color.Lavender)"
	DefaultToken = "$FG$($color.Wite)"
	Emphasis = "$($tag.HiLite)"
	Error = "$FG$($color.Black)"
	Keyword = "$FG$($color.OrangeJulius)"
	Member = "$FG$($color.ButterScotch)"
	Number = "$FG$($color.Grey)"
	Operator = "$FG$($color.CandyRed)"
	Parameter = "$FG$($color.Azure)"
	Selection = "$BG$($color.PSBlue)"
	String = "$FG$($color.Poppy)"
	Type = "$FG$($color.Turquoise)"
	Variable = "$FG$($color.LimeGreen)"
}

# Function for displaying colors

function Get-ColorSwatches () {
    param(
        [int]$Columns=4,
        [int]$Padding=21,
        [decimal]$Size=3,
        [switch]$colors,
        [switch]$xterms=$false
    )
    $Spaces = "".PadRight($($Size * 2)," ")
    if ($xterms) {$array=$xterm.Keys; $colors=$false}
    if ($colors) {$array=$color.Keys; $Columns=5; $Padding=13}
    $array | ForEach-Object {
        $counter += 1
        if ($xterms) {$colorBit = "$($xterm.$_.tbit)"}
        if ($colors) {$colorBit = "$($color.$_)"}
        $line1 += "$BG$colorBit$Spaces$Clir " + "$_".PadRight($Padding," ")
        $line2 += "$BG$colorBit$Spaces$Clir " + "  ".PadRight($Padding," ")
        if ((($counter % $Columns) -eq 0) -or ($counter -eq $array.Count)) {
            foreach ($i in 1..$Size) {
                if ($i -eq ([math]::Round(($Size + 0.5) / 2))) {Write-Host $line1} else {Write-Host $line2}
            }
        }
        if (($counter % $Columns) -eq 0) {$line1 = ""; $line2 = ""}
        }
        $line1 = ""; $line2 = ""; $counter = 0
}
Set-Alias -Name gcsw -Value Get-ColorSwatches
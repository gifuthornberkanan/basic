#--- Color Definitions File ---


#--- Formatting stuff ---

#$global:Color           = $([char]27)       #Escape character
#$global:Colour          = $([char]0x1b)     #Escape character
$global:BG              = "$([char]27)[48;"            #introduces background color changes
$global:FG              = "$([char]0x1b)[38;"            #introduces foreground color changes
$global:Clir            = "$([char]0x1b)[00m"            #ends a color sequence

#--- Create Color Objects ---

$color_template_variable = [PSCustomObject]@{
    r = 0
    g = 0
    b = 0
    xterm = -1
}
$color_template_variable | Add-Member -MemberType ScriptMethod -Name rgb -Force -Value {Write-Host "rgb`($($this.r),$($this.g),$($this.b)`)"}
$color_template_variable | Add-Member -MemberType ScriptMethod -Name hex -Force -Value {Write-Host "#$('{0:x2}' -f $this.r)$('{0:x2}' -f $this.g)$('{0:x2}' -f $this.b)"}
$color_template_variable | Add-Member -MemberType ScriptMethod -Name ccs -Force -Value {Write-Host "2;$($this.r);$($this.g);$($this.b)m"}
$color_template_variable | Add-Member -MemberType ScriptMethod -Name xcs -Force -Value {Write-Host "5;$($this.xterm)m"}

$global:color = @{

    #--- xTerm256 color codes ---
    xRedd = @{
        rgb = '2;175;0;0m'
        xterm = '5;124m'
    }
    xOrnj = @{
        rgb = '2;215;95;0m'
        xterm = '5;166m'
    }          
    xYelo = @{
        rgb = '2;223;175;0m'
        xterm = '5;178m'
    }
    xGrin = @{
        rgb = '2;0;215;0m'
        xterm = '5;40m'
    }
    xBloo = @{
        rgb = '2;0;135;255m'
        xterm = '5;33m'
    }
    xMppl = @{ #Prpl
        rgb = '2;175;95;255m'
        xterm = '5;135m'
    }
    xWite = @{
        rgb = '2;255;255;255m'
        xterm = '5;15m'
    }
    xSlet = @{
        rgb = '2;135;95;255m'
        xterm = '5;99m'
    }
    xVlet = @{
        rgb = '2;135;0;215m'
        xterm = '5;92m'
    }
    xMprp = @{ #Tym2
        rgb = '2;175;135;255m'
        xterm = '5;141m'
    }
    xPrpl = @{ #Tym3
        rgb = '2;175;0;255m'
        xterm = '5;129m'
    }

    #--- RGB color codes ---

    # Reds
    Red             = "2;255;00;00m"    #Plain ol' red
    CandyRed        = "2;255;44;75m"    #Taken from Badwolf color theme in Vim
    Salmon          = "2;250;128;114m"
    Pink            = "2;255;182;193m"
    Magenta         = "2;255;20;147m"

    # Oranges
    OrangeJulius    = "2;255;167;36m"   #Taken from Badwolf color theme in Vim
    Butterscotch    = "2;244;207;134m"  #Taken from Badwolf color theme in Vim
    Poppy           = "2;255;175;0m"    #Taken from Badwolf color theme in Vim

    # Yellows
    Brown           = "2;120;66;18m"
    Golden          = "2;241;196;15m"
    Yellow          = "2;255;255;0m"
    Caramel         = "2;186;74;0m"
    Tan             = "2;210;180;140m"

    # Greens
    LimeGreen       = "2;174;238;0m"    #Taken from Badwolf color theme in Vim
    SeaFoamGreen    = "2;118;215;196m"
    Khaki           = "2;240;230;140m"
    Green           = "2;0;255;0m"

    # Blues
    Blue            = "2;0;0;255m"
    Cyan            = "2;0;255;255m"
    Turquoise       = "2;64;224;208m"
    SkyBlue         = "2;135;206;250m"
    Azure           = "2;10;157;255m"   #Taken from Badwolf color theme in Vim
    PSBlue          = "2;0;26;56m"      #Default PowerShell console window background color

    # Purples
    Lavender        = "2;230;230;250m"
    Orchid          = "2;218;112;214m"
    Purple          = "2;128;0;128m"

    # Monochromes
    Silver          = "2;192;192;192m"
    Charcoal        = "2;20;20;19m"     #my preferred console window background color
    Grey            = "2;153;143;132m"  #Taken from Badwolf color theme in Vim
    Canvas          = "2;248;246;242m"  #Taken from Badwolf color theme in Vim
    Black           = "2;0;0;0m"
    White           = "2;255;255;255m"
}

#--- Custom Combos ---
$global:tag = @{
    Result = "$FG$($color.PSBlue)$BG$($color.xWite.xterm)"
    HiLite = "$FG$($color.Charcoal)$BG$($color.xYelo.xterm)"
}

<#   
$global:Colour = [char]27 #This is the escape char
$global:PSBluFG  = "[38;2;0;26;56m" #This is the RGB code of my current PShell window background.
$global:WiteBG  = "[48;2;255;255;255m" #This is the color white.
$global:Redd   = "[38;5;124m" #colorRed    HEX - 0xaf0000 | RGB - 175,000,000 | [38;2;255;00;00m
$global:Ornj   = "[38;5;166m" #colorOrange HEX - 0xd75f00 | RGB - 215,095,000
$global:Yelo   = "[38;5;178m" #colorYellow HEX - 0xdfaf00 | RGB - 223,175,000
$global:Grin   = "[38;5;40m"  #colorGreen  HEX - 0x00d700 | RGB - 000,215,000
$global:Bloo   = "[38;5;33m"  #colorBlue   HEX - 0x0087ff | RGB - 000,135,255
$global:Mppl   = "[38;5;135m" #colorPurple HEX - 0xaf5fff | RGB - 175,095,255
$global:Wite   = "[38;5;15m"  #colorWhite  HEX - 0xffffff | RGB - 255,255,255
$global:Clir   = "[00m"
$global:Tym1   = "[38;5;92m"  #Violet
$global:Tym2   = "[38;5;141m" #Orchid
$global:Tym3   = "[38;5;129m" #Lavender
$global:ResultTag = "$Colour$PSBluFG$Colour$WiteBG"
$global:ResultTagDummy = "$Colour$Clir"
#>
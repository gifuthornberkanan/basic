#--- Color Definitions File ---


#--- Formatting stuff ---

# 2 * 10^1 + 7 * 10^0 = 1 * 16^1 + 11*16^0 :: dec 27 = hex 1b
$global:BG   = "$([char]27)[48;"     # introduces background color changes
$global:FG   = "$([char]27)[38;"     # introduces foreground color changes
$global:CL   = "$([char]0x1b)[00m"   # ends a color sequence
$global:Clir = "$([char]0x1b)[00m"   # ends a color sequence

#--- Create Color Objects ---

$primaries   = @("Reds", "Greens", "Blues", "Achromatic")
$secondaries = @("Reds", "Yellows", "Greens", "Cyans", "Blues", "Magentas", "Achromatic")
$tertiaries  = @("Reds", "Oranges", "Yellows", "Limes", "Greens", "Teals", "Cyans",
                 "Azures", "Blues", "Purples", "Magentas", "Pinks", "Achromatic")

#--- Custom Combos ---

$global:tag = @{
    Result  = "$FG$( $xterm.PSBlue.tbit   )$BG$( $xterm.White.tbit    )"
    HiLite  = "$FG$( $xterm.Charcoal.tbit )$BG$( $xterm.GoldDeep.tbit )"
    Verbose = "$FG$( $xterm.Yellow.tbit   )$BG$( $xterm.Charcoal.tbit )"
}

#--- Console Host Window and PSReadline settings ---

#$host.PrivateData.ErrorForegroundColor     = 'White'
$host.PrivateData.ErrorBackgroundColor      = 'Black'
#$host.PrivateData.VerboseForegroundColor   = 'Magenta'

Set-PSReadLineOption -Colors @{
    Command            = "$FG$($xterm.Red.tbit)"
    Comment            = "$FG$($xterm.Gray.tbit)"
    ContinuationPrompt = "$FG$($xterm.Lavendar.tbit)"
    DefaultToken       = "$FG$($xterm.Roseine.tbit)"
    Emphasis           = "$($tag.HiLite)"
    Error              = "$FG$($xterm.Golden.tbit)"
    Keyword            = "$FG$($xterm.OrangeJulius.tbit)"
    Member             = "$FG$($xterm.ButterScotch.tbit)"
    Number             = "$FG$($xterm.Violet.tbit)"
    Operator           = "$FG$($xterm.CandyRed.tbit)"
    Parameter          = "$FG$($xterm.Azure.tbit)"
    Selection          = "$BG$($xterm.PSBlue.tbit)"
    String             = "$FG$($xterm.Marigold.tbit)"
    Type               = "$FG$($xterm.RobinsEgg.tbit)"
    Variable           = "$FG$($xterm.LimeGreen.tbit)"
} -ContinuationPrompt "-"


#--- Color Definitions File ---


#--- Formatting stuff ---

# 2 * 10^1 + 7 * 10^0 = 1 * 16^1 + 11*16^0 :: dec 27 = hex 1b
$global:BG   = "$([char]27)[48;"     # introduces background color changes
$global:FG   = "$([char]27)[38;"     # introduces foreground color changes
$global:CL   = "$([char]0x1b)[00m"   # ends a color sequence
$global:Clir = "$([char]0x1b)[00m"   # ends a color sequence

$global:leftArrow = [char]0xe0b0
$global:riteArrow = [char]0xe0b2
$global:leftAngle = [char]0xe0b1
$global:riteAngle = [char]0xe0b3

$global:dozenalTen = [char]0x218a
$global:dozenalElf = [char]0x218b


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
$host.PrivateData.ErrorBackgroundColor      = 'DarkMagenta'
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

#--- Function for displaying colors ---

function Get-ColorCardsAndSwatches () {
    [CmdLetBinding()]
    param(
        [Parameter( ParameterSetName = 'Family', Position = 1)]
        [ValidateSet( "primaryGroup", "secondaryGroup", "tertiaryGroup" )]
        [string]$Level,
        
        # This is the original parameter. I wrote a whole DynamicParam block below to replace
        # it so that the data validation would change based on the validated data in Level.
        #[Parameter(ParameterSetName = 'Family' )]
        #[string]$Family,

        # if you just want to pass a few colors to compare to each other.
        [Parameter( ParameterSetName = 'Custom' )]
        [string[]]$Set,

        # if you want to see EVERYTHING!
        [Parameter( ParameterSetName = 'All')]
        [switch]$All,

        # I still don't know if I should just ditch swatches alltogether. Cards are better,
        # IMO and I still don't have a good way to display the hex string and hue value
        # lines in the swatch version.
        [switch]$Swatches,

        # These bottom 3 are used to set up the Swatches. I think I may want to make this
        # automatic someday. Then I can delete the parameters.
        [ValidateRange( 1, 6 )]
        [int] $Columns = 4,

        [int] $Padding = 21,

        [ValidateRange( 1, 9 )]
        [decimal] $Size = 3

    )

    DynamicParam {
        # If you used the "-Level" parameter.
        if ($Level) {
            # Determine which data validation set to use for "-Family" based on the value of "-Level".
            switch ($Level) {
                "primaryGroup" { $FamilySet = $primaries }
                "secondaryGroup" { $FamilySet = $secondaries }
                "tertiaryGroup" { $FamilySet = $tertiaries }
                Default { }
            }
            # Create param name.
            $FamParameterName = 'Family'

            # Create attribute object and set it's built-in values.
            $FamAttribute = New-Object System.Management.Automation.ParameterAttribute
            $FamAttribute.Position = 2
            $FamAttribute.Mandatory = $true
            $FamAttribute.ParameterSetName = 'Family'
            $FamAttribute.DontShow = $false
            
            # Create a new collection. I think simple attributes can't be added to dictionaries.
            $FamCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $FamCollection.Add($FamAttribute)

            # Tell the collection what to use for data validation.
            $FamValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($FamilySet)
            $FamCollection.Add($FamValidateSetAttribute)

            # Create runtime Param.
            $FamRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($FamParameterName, [string], $FamCollection)

            # Create runtime dictionary.
            $FamRuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $FamRuntimeParameterDictionary.Add($FamParameterName, $FamRuntimeParameter)

            # Implement the damn parameter already!
            return $FamRuntimeParameterDictionary
        }
    }

    # When you use a DynamicParam block, you MUST use begin, process, and end blocks.
    # I found that out the hard way.
    begin {
        # Determine which type of input we have and use it to prepare an array
        switch ($PSCmdlet.ParameterSetName) {
            "Family" {
                $xterm.Keys | ForEach-Object {
                    # Also you can't just call the parameter variable for a dynamic param
                    # the same way you'd call a regular param. You have to call it from 
                    # $PSBoundParameters explicitly.
                    if ($PSBoundParameters.Family -eq $xterm.$_.$Level) {
                        $ColorNamePreArray += @($_)
                    }
                }
                $ColorNameArray = $ColorNamePreArray | Sort-Object { $xterm.$_.hueOrder }
            }
            "Custom" {
                $ColorNameArray = $Set
            }
            "All" {
                $ColorNameArray = $xterm.Keys | Sort-Object { $xterm.$_.hueOrder }
            }
        }

        # This is so no one can mess with the cards display.
        if ($Swatches -eq $false) { $Columns = 6 }
    }

    # Take the array we just perpared and iterate over each item in it.
    process {
        $ColorNameArray | ForEach-Object {
            $Counter += 1

            $colorBit = $xterm.$_.tbit

            if ($Swatches) {
                # The setup here is that the output is a square with the color name next to it.
                # so you have lines that are "<COLOR><DATA>" and others that are "<COLOR><BLANKSPACE>"
                $line1 += "$BG$colorBit$(" " * ($Size * 2))$CL " + "$_".PadRight( $Padding, " " )
                $line2 += "$BG$colorBit$(" " * ($Size * 2))$CL " + "  ".PadRight( $Padding, " " )

                # This loop is set up so that the color name outside the square swatch will always be
                # either next to the middle row (if $Size is odd) or the upper of the two middle rows
                # (if $Size is even).
                if ( ( ( $Counter % $Columns ) -eq 0 ) -or ( $Counter -eq $ColorNameArray.Count ) ) {
                    foreach ( $i in 1..$Size ) {
                        if ( $i -eq ([math]::Round( ( $Size + 0.5 ) / 2) ) ) { Write-Host $line1 }
                        else { Write-Host $line2 }
                    }
                }
            }
            else {
                # This executes when you want cards (i.e. you didn't go out of your way to choose swatches).
                # $line1 is the color name and then the color itself to the end of the card.
                # $line2 is the color's hex string then the color to the end.
                # $line3 is the color's hue value formatted to 2 decimal places, then the color...
                # $line4 is just the color itself and will be used to fill out the majority of the card's area.
                $line1 += "$_$BG$colorBit$(" " * (20 - "$_".Length) )$CL"
                $line2 += "$($xterm.$_.hexString)$BG$colorBit$(" " * 13)$CL"
                $hue = "{0:f2}" -f $xterm.$_.h
                $line3 += "$hue$BG$colorBit$(" " * $(20 - $hue.Length))$CL"
                $line4 += "$BG$colorBit$(" " * 20)$CL"

                # This loop is much simpler than the one above since all lines are always in the same place.
                if ( ( ( $Counter % 6 ) -eq 0 ) -or ( $Counter -eq $ColorNameArray.Count ) ) {
                    Write-Host $line1
                    Write-Host $line2
                    Write-Host $line3
                    foreach ( $i in 4..6 ) {
                        Write-Host $line4
                    }
                }
            }

            # Make sure to reset your variables after writing each line. Or bad things will happen. BAD THINGS.
            if ( ( $Counter % $Columns ) -eq 0 ) { $line1 = ""; $line2 = ""; $line3 = ""; $line4 = "" }
        }
    }

    # This was probably more necessary when this function lived only on the CLI. Oh well.
    end {
        $line1 = ""; $line2 = ""; $line3 = ""; $line4 = ""; $Counter = 0
    }
}

#--- Functions for setting color themes ---
function Set-ColorThemeValues () {
    # This will change individual FG or BG prompt settings.
    param(
        [string]$NewColor,
        [Parameter( Mandatory = $true,
            ParameterSetName = 'Text' )]
        [ValidateRange( 1, 6 )]
        [int]$Text,
        [Parameter( Mandatory = $true,
            ParameterSetName = 'Back' )]
        [ValidateRange( 1, 6 )]
        [int]$Back
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Back" { $ThemeNum = $Back; $Theme = "a"; $Number = $Back + 10 }
        "Text" { $ThemeNum = $Text; $Theme = "b"; $Number = $Text + 20 }
    }

    $file = Get-Content -Path $ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\color_themes.ps1

    $file[$Number] = "`$theme$ThemeNum$Theme = `$xterm.$NewColor.tbit"

    $file | Set-Content -Path $ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\color_themes.ps1

}

function Set-ColorTheme () {
    # This will swap out every theme color for a preset.
    param(
        [string]$Theme
    )

    . "$ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\color_themes\$Theme.ps1"

    # $PSColorTheme is imported when the theme script file is dot sourced.
    # it contains settings for all 6 text and all 6 background colors.
    $PSColorTheme | ForEach-Object {
        $Themelet = $_
        Set-ColorThemeValues @Themelet # Yay splatting!
    }
}

function Get-ColorTheme () {

    param(
        [string]$Theme
    )

    $ThemePath = "$ENV:USERPROFILE\Documents\WindowsPowerShell\Scripts\color_themes"

    if ($Theme) {
        . "$ThemePath\$Theme.ps1"
        Write-Host "$Theme`: "
        $PSColorTheme
    } else {
        $AllFiles = Get-ChildItem -Path $ThemePath -Filter *.ps1 -Recurse -File -Name
        $AllFiles | Foreach-Object {$FileOut += @($_.Trim(".ps1"))}
        $FileOut
    }
}

#--- Function for converting RGB values to HSL ---
<#
https://badflyer.com/powershell-color-conversion
Convert-RGBToHSLModified is a modified version of Convert-RGBToHSL by badflyer
#>
function Convert-RGBToHSLModified {
    [CmdLetBinding()]
    param
    (
        [Parameter( Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 0xFF)][int]$Red,
        [Parameter( Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 0xFF)][int]$Green,
        [Parameter( Mandatory = $true,
            Position = 2,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 0xFF)][int]$Blue
    )
    process {
        $arry = @(($red / 255), ($green / 255), ($blue / 255))
        $max = 0
        $min = 0
        for ($i = 1; $i -lt $arry.Length; $i++) {
            if ($arry[$i] -gt $arry[$max]) {
                $max = $i
            }

            if ($arry[$i] -lt $arry[$min]) {
                $min = $i
            }
        }
        $C = $arry[$max] - $arry[$min]
        $hue = 0
        $lightness = 0
        if (0 -ne $C) {
            $hue = ($arry[($max + 4) % 3] - $arry[($max + 5) % 3]) / $C

            if (0 -eq $max) {
                $hue %= 6
            }
            else {
                $hue += 2 * $max
            }

            $hue *= 60
            if ($hue -lt 0) { $hue = $hue + 360 }
            $lightness = 0.5 * ($arry[$min] + $arry[$max])
            $saturation = $C / (1 - [Math]::Abs(2.0 * $lightness - 1)) * 100
            $lightness *= 100
        }
        return [pscustomobject]@{
            hue         = $( "{0:N2}" -f $hue)
            saturation  = $( "{0:N2}" -f $saturation)
            lightness   = $( "{0:N2}" -f $lightness)
            red         = $( "{0:N2}" -f $red)
            green       = $( "{0:N2}" -f $green)
            blue        = $( "{0:N2}" -f $blue)
        }
    }
}

function Get-ClosestXTermColor () {
    param(
        [Parameter(ParameterSetName = "Lumped")]
        [string]$HexString,

        [Parameter(ParameterSetName = "Split")]
        [int32]$red,

        [Parameter(ParameterSetName = "Split")]
        [int32]$green,

        [Parameter(ParameterSetName = "Split")]
        [int32]$blue
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Lumped" {
            $r = "0x$($HexString.Substring(1,2))"
            $g = "0x$($HexString.Substring(3,2))"
            $b = "0x$($HexString.Substring(5,2))"
        
            $red   = [int32]$r
            $green = [int32]$g
            $blue  = [int32]$b
        }
        "Split" { }
    }

    Write-Host "Red was: $red, Green was: $green, Blue was $blue"
    
    $red, $green, $blue | ForEach-Object {
        $ReusableVariable = $_
        $ReusableVariable = $ReusableVariable - 15
        $ReusableVariable = $ReusableVariable / 40
        $ReusableVariable = [math]::Round($ReusableVariable)
        $ReusableVariable = $ReusableVariable * 40
        $ReusableVariable = $ReusableVariable + 15
        if ($ReusableVariable -eq 15) { $ReusableVariable = 0 }
        if ($ReusableVariable -eq 55) { $ReusableVariable = 95 }
        $RGB += @($ReusableVariable)
    }

    $red   = $RGB[0]
    $green = $RGB[1]
    $blue  = $RGB[2]

    Write-Host "After fixing:"
    Write-Host "Red is: $red, Green is: $green, Blue is $blue"
    Write-Host "Closest xterm color is..."

    $xterm.Keys | ForEach-Object {
        if (( $xterm.$_.r -eq $red  ) -and 
            ( $xterm.$_.g -eq $green) -and 
            ( $xterm.$_.b -eq $blue )) {
            Write-Host "$_`:" $xterm.$_.hexString
        }
    }
}

function Get-NewHueOrderNumber () {
    param(
        [int]$red,
        [int]$green,
        [int]$blue
    )

    $HSLVariable = Convert-RGBToHSLModified -Red $red -Green $green -Blue $blue

    $xterm.Keys | ForEach-Object {
        if ($xterm.$_.h -ge $HSLVariable.hue) {
            if (($xterm.$_.h - $HSLVariable.hue) -lt 8) { $AboveHSLArray += @($_) }
        }
        if ($xterm.$_.h -le $HSLVariable.hue) {
            if (($HSLVariable.hue - $xterm.$_.h) -lt 8) { $BelowHSLArray += @($_) }
        }
    }

    $ColorNameArray = $BelowHSLArray | Sort-Object { $xterm.$_.hueOrder }
    $ColorNameArray += $AboveHSLArray | Sort-Object { $xterm.$_.hueOrder }

    foreach ($ColorName in $ColorNameArray) {
        Write-Host "$($ColorName.PadRight(20," "))" -NoNewline
        Write-Host "ord: $($([string]$xterm.$ColorName.hueOrder).PadRight(10, " "))" -NoNewline
        Write-Host "hue: $($([string]$xterm.$ColorName.h).PadRight(10," "))" -NoNewline
        Write-Host "sat: $($([string]$xterm.$ColorName.s).PadRight(10," "))" -NoNewline
        Write-Host "lgt: $($([string]$xterm.$ColorName.l).PadRight(10," "))"
    }
}

function Get-HueOrder () {
    param(
        [double]$HueInQuestion
    )
    $SmallestDifferenceAbove = 361
    $SmallestDifferenceBelow = 361
    foreach ($clr in $xterm.Keys) {
        if ($xterm.$clr.h -gt $HueInQuestion) {
            if (($xterm.$clr.h - $SmallestDifferenceAbove) -lt $HueInQuestion) {
                $SmallestDifferenceAbove = $xterm.$clr.h - $HueInQuestion
                $ClosestColorNameAbove = $clr
            }
        } elseif ($xterm.$clr.h -lt $HueInQuestion) {
            if (($xterm.$clr.h + $SmallestDifferenceBelow) -gt $HueInQuestion) {
                $SmallestDifferenceBelow = $HueInQuestion - $xterm.$clr.h
                $ClosestColorNameBelow = $clr
            }
        }
    }
    $SmallestDifferenceAbove
    $ClosestColorNameAbove
    $SmallestDifferenceBelow
    $ClosestColorNameBelow
}

function Get-ColorLevelFamily () {        # WORK IN PROGRESS!!!!!!!
    param(
        [Parameter(ParameterSetName = "Lumped")]
        [string]$HexString,

        [Parameter(ParameterSetName = "Split")]
        [int32]$red,

        [Parameter(ParameterSetName = "Split")]
        [int32]$green,

        [Parameter(ParameterSetName = "Split")]
        [int32]$blue,

        [switch]$SendToClip
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Lumped" {
            $r = "0x$($HexString.Substring(1,2))"
            $g = "0x$($HexString.Substring(3,2))"
            $b = "0x$($HexString.Substring(5,2))"
        
            $red = [int32]$r
            $green = [int32]$g
            $blue = [int32]$b
        }
        "Split" { }
    }

    $cmax = [math]::Max($red,$([math]::Max($green,$blue)))
    $cmin = [math]::Min($red,$([math]::Min($green,$blue)))

    if ($cmax - $cmin -le 9) {
        $pGroup = "Achromatic"
        $sGroup = "Achromatic"
        $tGroup = "Achromatic"
    }
    else {
        $temphue = $([double]$(Convert-RGBToHSLModified -Red $red -Green $green -Blue $blue).hue * 100)
        switch ($temphue) {
            {     0..5799  -contains $_ } { $pGroup = "Reds"     }
            {  5800..16999 -contains $_ } { $pGroup = "Greens"   }
            { 17000..29099 -contains $_ } { $pGroup = "Blues"    }
            { 29100..36000 -contains $_ } { $pGroup = "Reds"     }
        }
        switch ($temphue) {
            {     0..4599  -contains $_ } { $sGroup = "Reds"     }
            {  4600..6999  -contains $_ } { $sGroup = "Yellows"  }
            {  7000..16999 -contains $_ } { $sGroup = "Greens"   }
            { 17000..19999 -contains $_ } { $sGroup = "Cyans"    }
            { 20000..27499 -contains $_ } { $sGroup = "Blues"    }
            { 27500..33299 -contains $_ } { $sGroup = "Magentas" }
            { 33300..36000 -contains $_ } { $sGroup = "Reds"     }
        }
        switch ($temphue) {
            {     0..1599  -contains $_ } { $tGroup = "Reds"     }
            {  1600..4599  -contains $_ } { $tGroup = "Oranges"  }
            {  4600..6599  -contains $_ } { $tGroup = "Yellows"  }
            {  6600..11999 -contains $_ } { $tGroup = "Limes"    }
            { 12000..14699 -contains $_ } { $tGroup = "Greens"   }
            { 14700..17099 -contains $_ } { $tGroup = "Teals"    }
            { 17100..18299 -contains $_ } { $tGroup = "Cyans"    }
            { 18300..21099 -contains $_ } { $tGroup = "Azures"   }
            { 21100..25299 -contains $_ } { $tGroup = "Blues"    }
            { 25300..28999 -contains $_ } { $tGroup = "Purples"  }
            { 29000..31499 -contains $_ } { $tGroup = "Magentas" }
            { 31500..35099 -contains $_ } { $tGroup = "Pinks"    }
            { 35100..36000 -contains $_ } { $tGroup = "Reds"     }
        }
    }
    $output = `
@"
primaryGroup   = "$pGroup"
secondaryGroup = "$sGroup"
tertiaryGroup  = "$tGroup"
"@

    if ($SendToClip) { Set-Clipboard $output }

    return [PSCustomObject]@{
        primaryGroup   = $pGroup
        secondaryGroup = $sGroup
        tertiaryGroup  = $tGroup
    }
}

function Get-ColorInverse () {
    param(
        [Parameter(ParameterSetName = "hexString")]
        [string]$hexString,

        [Parameter(ParameterSetName = "tbit")]
        [string]$tbit
    )

    switch ($PSCmdlet.ParameterSetName) {
        "tbit" {
            $tbit2 = $tbit.Trim("m")
            $tbit3 = @($tbit2.Split(";"))

            $r = $tbit3[1]
            $g = $tbit3[2]
            $b = $tbit3[3]
        }
        "hexString" {
            $r = "{0:N}" -f "0x$($hexString.Substring(1,2))"
            $g = "{0:N}" -f "0x$($hexString.Substring(3,2))"
            $b = "{0:N}" -f "0x$($hexString.Substring(5,2))"
        }
    }

    $InverseR = 255 - $r
    $InverseG = 255 - $g
    $InverseB = 255 - $b

    switch ($PSCmdlet.ParameterSetName) {
        "tbit" {
            return "2;$($InverseR);$($InverseG);$($InverseB)m"
        }
        "hexString" {
            return "#$("{0:x2}" -f $InverseR)$("{0:x2}" -f $InverseG)$("{0:x2}" -f $InverseB)"
        }
    }


}
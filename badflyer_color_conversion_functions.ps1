<#
https://badflyer.com/powershell-color-conversion
#>
<#
badflyer
Powershell Color Conversions
Peter Sulucz - July 10, 16

Alright. I was in a bit of a groove last night. I was up till 3, but I do have something amazing to show for it. Like literally fantastic. I have no idea how humanity got to this point without some of this code. So without further ado how about some scripts for doing color conversions in powershell. They aren't commented amazingly. Well the first one is ok. But the other ones suck. Anyway, here it is. These are based entirely off of the wikipedia article on HSV and HSL. I did my best to use those formulas exaclty so everything *SHOULD* work.
#>

#
# All of these functions are based on the formulas provided on WikiPedia for color conversions
# So check them out for more info https://en.wikipedia.org/wiki/HSL_and_HSV
#

#
# Converts from Hue Saturation Lightness to RGB
#
function Convert-HSLToRGB
{
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 360)][double]$Hue,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 1)][double]$Saturation,
        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 1)][double]$Lightness
    )
    process
    {
        # You will need to check wikipedia for this. Essentially
        # We take a cube, and project it on to a 2d surface.
        # Which gives us a hexagon. Seriously, look at wikipedia. 
        # It weird to think about, but imaging a rubix cube, sitting on one of its corners.
        # If you look directly down at it there will be one corner in the middle, and 6 along the side
        # The chroma is the distance from the center of the hexagon
        # The Hue is our angle along this hexagon.
        # WIKIPEDIA LOOK AT IT.

        # Calculate the chroma
        $chroma = (1 - [Math]::Abs(2.0*$Lightness - 1.0)) * $Saturation
        
        # Figure out which section of the hexagon we are in. (6 sections)
        $H = $Hue / 60.0
        $X = $chroma * (1.0 - [Math]::Abs($H % 2 - 1))

        # Get value for lightness
        $m = $Lightness - 0.5 * $chroma
        $rgb = @($m, $m, $m)

        # UGH this part.
        # ok. So this is what happens. [R, G, B] is definited peicewise.
        # 0 <= H < 1 then [C, X, 0]
        # 1 <= H < 2 then [X, C, 0]
        # 2 <= H < 3 then [0, C, X]
        # 3 <= H < 4 then [0, X, C]
        # 4 <= H < 5 then [X, 0, C]
        # 5 <= H < 6 then [C, 0, X]
        # So these calculate the index of the x value and the c value
        $xIndex = (7 - [Math]::Floor($H)) % 3
        $cIndex = [int]($H / 2) % 3

        # Add the values in
        $rgb[$xIndex] += $X
        $rgb[$cIndex] += $chroma

        # Return the value
        return [pscustomobject]@{red = [int]($rgb[0] * 255); green = [int]($rgb[1] * 255); blue = [int]($rgb[2] * 255)}
    }
}

#
# Converts from Hue Saturation Value to RGB
#
function Convert-HSVToRGB
{
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 360)][double]$Hue,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 1)][double]$Saturation,
        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 1)][double]$Value
    )
    process
    {
        # This one works very similar to the funciton above, so take a look there for comments
        $chroma = $Value * $Saturation
        $H = $Hue / 60.0
        $X = $chroma * (1.0 - [Math]::Abs($H % 2 - 1))

        $m = $Value - $chroma
        $rgb = @($m, $m, $m)

        $xIndex = (7 - [Math]::Floor($H)) % 3
        $cIndex = [int]($H / 2) % 3

        $rgb[$xIndex] += $X
        $rgb[$cIndex] += $chroma

        return [pscustomobject]@{red = [int]($rgb[0] * 255); green = [int]($rgb[1] * 255); blue = [int]($rgb[2] * 255)}
    }
}

#
# Converts from RGB to Hue Saturation Value
#
function Convert-RGBToHSV
{
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Red,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Green,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Blue
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
        $saturation = 0
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
            $value = $arry[$max]
            $saturation = $C / $value
        }
        return [pscustomobject]@{hue = $hue; saturation = $saturation; value = $value}
    }
}

#
# Converts from RGB to Hue Saturation Lightness
#
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
            $lightness = 0.5 * ($arry[$min] + $arry[$max])
            $saturation = $C / (1 - [Math]::Abs(2.0 * $lightness - 1))
        }
        return [pscustomobject]@{hue = $hue; saturation = $saturation; lightness = $lightness}
    }
}

#
# Splits an integer RGB value into 3 parts
#
function Split-RGB
{
    param
    (
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 0xFFFFFF)][int]$RGB
    )
    process
    {
        return [pscustomobject]@{red = ($RGB -shr 16); green = (($RGB -shr 8) -band 0xFF); blue = ($RGB -band 0xFF)}
    }
}

#
# Combines the rgb components into a single value
#
function Join-RGB
{
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Red,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Green,
        [Parameter(Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Blue
    )
    process
    {
        return ($Red -shl 16) -bor ($Green -shl 8) -bor $Blue
    }
}

#
# Just gets an rgb color object
#
function Get-RGBColor
{
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Red,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Green,
        [Parameter(Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)][ValidateRange(0, 0xFF)][int]$Blue
    )
    process
    {
        return [pscustomobject]@{red = $Red; green = $Green; blue = $Blue}
    }
}

# Test
# Join-RGB -Red 45 -Green 32 -Blue 222 | Split-RGB | Join-RGB | Split-RGB
# Get-RGBColor 10 20 30 | Convert-RGBToHSL | Convert-HSLToRGB
# Get-RGBColor 10 20 30 | Convert-RGBToHSV | Convert-HSVToRGB
# Get-RGBColor 10 20 30 | Convert-RGBToHSV | Convert-HSVToRGB | Convert-RGBToHSL | Convert-HSLToRGB

<#
So yea. There is it. I hope someone can make use of these things. I don't really have I use for them, just a need to fight something throught until it is done. So my issue is that I was working on a side project, and we were using an external web service, which always returned colors in HSL. To be honest, I had no idea what that was, so I did some reading and had to write a function to convert to RGB. RGB makes SO much more sense... to me.

badflyer
© 2019 - Peter Sulucz
#>
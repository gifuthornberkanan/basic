function ConvertTo-NonDecimalRadix () {
    [CmdletBinding()]
    param(
        [ValidateRange( 2, 48 )]
        [int32]$Base,
        [int32]$Number
    )

    while ( $Number -ge [math]::pow( $Base, $Place ) ) {
        $Place += 1
    }

    $Numerals = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÅÆÇÐÑØÞßŊǶǷȜ" ### This allows up to Base 48

    $Place -= 1

    For ( $Place; $Place -ge 0; $Place-- ) {
        while ( $Number -ge [math]::pow( $Base, $Place ) ) {
            $Number -= $( [math]::pow( $Base, $Place ) )
            $Increment += 1
        }
        $CurrentNumeral = $Numerals.Substring($Increment,1)
        $Output         = "$Output$CurrentNumeral"
        $Increment      = 0
    }

    return $Output
}
Set-Alias -Name ConvertFrom-DecimalRadix -Value ConvertTo-NonDecimalRadix
Set-Alias -Name ConvertFrom-Base10       -Value ConvertTo-NonDecimalRadix
Set-Alias -Name ConvertTo-NonBase10      -Value ConvertTo-NonDecimalRadix

function ConvertFrom-NonDecimalRadix () {
    [CmdletBinding()]
    param (
        [ValidateRange( 2, 48 )]
        [int32]$Base,
        [string]$Number
    )

    $Number = $Number.ToUpper()
    $Rebmun = $Number.ToCharArray()
    [array]::Reverse( $Rebmun )
    $Number = -join( $Rebmun )
    $Numerals = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÅÆÇÐÑØÞßŊǶǷȜ" ### This allows up to Base 48

    For ( $Place = 0; $Place -le $($Number.Length - 1); $Place++ ) {
        $Numeral = $Number[$Place]
        $Digit   = $Numerals.IndexOf($Numeral)
        $Output  =  $Output + ( $Digit * ( [math]::pow( $Base, $Place ) ) )
    }

    return $Output
}
Set-Alias -Name ConvertTo-DecimalRadix -Value ConvertFrom-NonDecimalRadix
Set-Alias -Name ConvertTo-Base10       -Value ConvertFrom-NonDecimalRadix
Set-Alias -Name ConvertFrom-NonBase10  -Value ConvertFrom-NonDecimalRadix

#--- For a function that converts decimals to fractions ---#
function Convert-DecimalToFraction() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Number,

        [Parameter()]
        [switch]$ReducedFraction
    )
    ### Figure out what to do about patterns whose period is longer than the returned digits.
    ### If you don't want an exact fraction, multiply by (10^x) and then remove all factors of 2 and 5.

    ### Store input number in new variable that will be operated on so that the original can be brought
    ### back later for comparison.
    $NumberString = $Number
    Write-Verbose -Message "`$NumberString is..: $NumberString"

    ### Split the Integer off from the decimal.
    $IntegerString, $DecimalString = @( $NumberString.split( "." ) )
    if ( $IntegerString -eq "0" ) { $IntegerString = "" } else { $IntegerString = "$IntegerString " }
    Write-Verbose -Message "`$IntegerString is.: $IntegerString"
    Write-Verbose -Message "`$DecimalString is.: $DecimalString"

    ### Check for contiguous repeating patterns: ([0-9]+)\1
    $RepeatPattern = $( $DecimalString | Select-String -Pattern '(\d+)\1' -AllMatches | % { $_.Matches } | Select-Object -Property * )
    Write-Verbose -Message "`$RepeatPattern is.:"
    Write-Verbose -Message "      .Groups is..: $($RepeatPattern.Groups)"
    Write-Verbose -Message "      .Success is.: $($RepeatPattern.Success)"
    Write-Verbose -Message "      .Name is....: $($RepeatPattern.Name)"
    Write-Verbose -Message "      .Captures is: $($RepeatPattern.Captures)"
    Write-Verbose -Message "      .Index is...: $($RepeatPattern.Index)"
    Write-Verbose -Message "      .Length is..: $($RepeatPattern.Length)"
    Write-Verbose -Message "      .Value is...: $($RepeatPattern.Value)"

    ### Separate out the actual pattern from the object that Select-String -AllMatches returns.
    $MatchedPattern = $RepeatPattern.Value.ToString().Substring( 0, ( $RepeatPattern.Length / 2 ) )
    Write-Verbose -Message "`$MatchedPattern is: $MatchedPattern"

    ### This is the sequence between the decimal point and the first digit in the repeating pattern, if there is anything there.
    $ExtraBit = $DecimalString.Substring( 0, $RepeatPattern.Index )
    Write-Verbose -Message "`$Extrabit is......: $ExtraBit"

    # And get the starting and ending positions
    ### Create two quantities for subtraction.
    ## Move the decimal point to directly after the first iteration of the pattern
    $BigMultiple = [int64]$( "$ExtraBit$MatchedPattern" )
    Write-Verbose -Message "`$BigMultiple is...: $BigMultiple"

    # Make a note of how many places it moves. This will be the larger quantity: (10^a)x.
    $BigPower = ( [int64]$( "$ExtraBit$MatchedPattern" ).Length )
    Write-Verbose -Message "`$BigPower is......: $BigPower"

    ## Move the decimal point to directly before the first iteration of the pattern
    $LilMultiple = [int64]$( "$ExtraBit" )
    Write-Verbose -Message "`$LilMultiple is...: $LilMultiple"

    # Make a note of how many places it moves. This will be the smaller quantity: (10^b)x.
    $LilPower = ( [int64]$( "$ExtraBit" ).Length )
    Write-Verbose -Message "`$LilPower is......: $LilPower"

    ### Subtract the smaller quantity from the larger. This should eliminate the repeating decimal, leaving only an integer. This will be the numerator.
    ### We're taking a shortcut here by only subtracting the Integer parts since we already know the repeating decimal cancels out in this step, we
    ### don't actually need to do the math for that.
    $Numerator = $BigMultiple - $LilMultiple
    Write-Verbose -Message "`$Numerator is.....: $Numerator"

    ### Subtract the (10^b)x from (10^a)x to obtain the multiplier of "x". After balancing the equation, this will be the denominator.
    $Denominator = ( [math]::pow( 10, $BigPower ) ) - ( [math]::pow( 10, $LilPower ) )
    Write-Verbose -Message "`$Denominator is...: $Denominator"

    ### (Optionally) Find common factors to divide both N and D by and reduce the fraction.
    if ( $ReducedFraction ) {
        $NumFactors = Find-Factors $Numerator -AllPrimes
        $DenFactors = Find-Factors $Denominator -AllPrimes
        Compare-Object -ReferenceObject $NumFactors -DifferenceObject $DenFactors -IncludeEqual | ForEach-Object { if ( $_.SideIndicator -eq "==" ) { $CommonFactors += @( $_.InputObject ) } }
        $CommonFactors | ForEach-Object { $Numerator = $Numerator / $_; $Denominator = $Denominator / $_ }
    }

    ### Output the results.
    Write-Host -Object "The number '$Number' expressed as a fraction is: $IntegerString$Numerator / $Denominator`n"
    Write-Debug -Message "Error checking: Integer + (Numerator / Denominator) = $( [int64]$( $IntegerString ) + $( $Numerator / $Denominator ) )"
}
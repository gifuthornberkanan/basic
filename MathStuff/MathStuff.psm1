function Convert-ContFractionToDecimal () {
	param (
		[string[]]$Sequence,

		[string]$Presets,

		[switch]$DebugMode
	)

	switch ( $Presets ) {
		"e" {
			$intparts = @( 2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1, 10, 1, 1, 12, 1, 1, 14, 1 )
		}
		"phi" {
			$intparts = @( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
			, 1, 1, 1 )
		}
		"pi" {
			$intparts = @( 3, 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2, 1, 84 )
		}
		"tau" {
			$intparts = @( 6, 3, 1, 1, 7, 2, 146, 3, 6, 1, 1, 2, 7, 5, 5, 1, 4, 1, 2, 42, 5, 31 )
		}
		"root2" {
			$intparts = @( 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 )
		}
		"root3" {
			$intparts = @( 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2 )
		}
		"root5" {
			$intparts = @( 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 )
		}
		default {
			$Sequence = $( $Sequence -replace ";", "," )
			$intparts = @( $Sequence -split "," )
		}
		<# Template to be copy/pasted
		"" {
			$intparts = @()
		}
		#>
	}

	$eks = 1
	[array]::Reverse( $intparts )
	foreach ( $intgr in $intparts ) {
		$intgr = $intgr -as [int]
		$eks = $intgr + ( 1 / $eks )
		if ( $DebugMode ) { Write-Host "intgr is....$intgr"; Write-Host "eks is......$eks" }
	}
	Write-Output $eks
}

function Convert-ContFractionToFraction () {
	[double]$stuff = Convert-ContFractionToDecimal -Sequence $args
	Convert-DecimalToFraction $stuff
}

function Convert-DecimalToFractionOLD () {
	param (
		[System.Decimal]$ehn
	)

	$Numerator = $ehn
	$Denominator = 1

	if ( $Numerator -gt 1 ) {
		$IntegerPart = [int64][Math]::Truncate( $Numerator )
		$Numerator = $Numerator-$IntegerPart
	}

	do {
		$Numerator *= 10
		$Denominator *= 10
		$ModulusTestNumber = ( $Numerator % 1 )
	} until ( $ModulusTestNumber -eq 0 )

	[int64]$SquareRootLimit = $( [Math]::Sqrt( $Numerator )) + 1
	foreach ( $CurrentTestNumber in 2..$SquareRootLimit ) {
		$NumeratorModTest = $Numerator % $CurrentTestNumber
		$DenominatorModTest = $Denominator % $CurrentTestNumber
		if ( ( $NumeratorModTest -eq 0 ) -and ( $DenominatorModTest -eq 0 ) ) {
			while ( ( ( $Numerator % $CurrentTestNumber ) -eq 0 ) `
			-and ( ( $Denominator % $CurrentTestNumber ) -eq 0 ) ) {
				$Numerator = $Numerator / $CurrentTestNumber
				$Denominator = $Denominator / $CurrentTestNumber
			}
		}
	}

	[int64]$OutNumerator = $Numerator
	if ( $IntegerPart ) { Write-Host "$IntegerPart " -NoNewline }
	Write-Output "$OutNumerator / $Denominator"
}

function Convert-DecimalToContFraction () {
	param (
		[System.Decimal]$wai
	)

	for ( $ai; $ai -lt 20; $ai++ ) {
		Write-Output $wai
		$zee = [int][Math]::Truncate( $wai )
		$zed = $wai - $zee
		$omega = "$omega, $zee"
		$wai = 1 / $zed
	}
	$omega = $( $omega.TrimStart( ', ' ) )
	Write-Host $omega
}

function Find-Factors () {
	param (
		[double]$InputNumber,

		[switch]$AllFactors,

		[switch]$AllPrimes,

		[switch]$SinglePrimes,

		[switch]$ArrayNotString
	)

	# If none of the format switches are used, generate an error.
	if ( -not ( ( $AllFactors ) -or ( $AllPrimes ) -or ( $SinglePrimes ) ) ) {
		Write-Error -Message "Insufficient arguments. Please enter an output format from: AllFactors, AllPrimes, or SinglePrimes."
		Break
	}

	# I'm creating a copy of the input so I can modify that and keep the input the same.
	$ModifiedInputNumber = $InputNumber

	# Run through every number from 2 (the first prime numnber) to the input.
	foreach ( $CurrentTestNumber in 2..$InputNumber ) {
		# Take the remainder of modular division.
		$ModulusTestNumber = $ModifiedInputNumber % $CurrentTestNumber
		# If the modulus is zero, then do things.
		if ( $ModulusTestNumber -eq 0 ) {
			# Test for the use of $AllFactors.
			switch ( $AllFactors ) {
				True {
					#Write-Output "$CurrentTestNumber " -NoNewline
					$OutputString = "$OutputString $CurrentTestNumber"
				}
				# If $AllFactors is not used, then test for the other switches.
				Default {
					while ( $( $ModifiedInputNUmber % $CurrentTestNumber ) -eq 0 ) {
						# Since we already know the modulus is zero, division will always
						# yeild integer remainders.
						$ModifiedInputNumber = $ModifiedInputNumber / $CurrentTestNumber
						# Writing here lists the same prime multiple times.
						if ( $AllPrimes ) { $OutputString = "$OutputString $CurrentTestNumber" }
					}
					# Writing here lists each prime only once.
					if ( $SinglePrimes ) { $OutputString = "$OutputString $CurrentTestNumber" }
				}
			}
		}
	}

	# Generate output
	$OutputString = $OutputString.Trim()
	if ( $ArrayNotString ) { $OutputString = @( $OutputString -split " " ) }
	Write-Output -InputObject $OutputString
}

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

	if ( $RepeatPattern ) {
		### Separate out the actual pattern from the object that Select-String -AllMatches returns.
		$MatchedPattern = $RepeatPattern.Value.ToString().Substring( 0, ( $RepeatPattern.Length / 2 ) )
		Write-Verbose -Message "`$MatchedPattern is: $MatchedPattern"

		### This is the sequence between the decimal point and the first digit in the repeating pattern, if there is anything there.
		$ExtraBit = $DecimalString.Substring( 0, $RepeatPattern.Index )
	} else {
		$ExtraBit = $DecimalString
	}
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
        $NumFactors = Find-Factors $Numerator -AllPrimes -ArrayNotString
        $DenFactors = Find-Factors $Denominator -AllPrimes -ArrayNotString
		Write-Verbose -Message "`$NumFactors is....: $NumFactors"
		Write-Verbose -Message "`$DenFactors is....: $DenFactors"
        Compare-Object -ReferenceObject $NumFactors -DifferenceObject $DenFactors -IncludeEqual | ForEach-Object { if ( $_.SideIndicator -eq "==" ) { $CommonFactors += @( $_.InputObject ) } }
		Write-Verbose -Message "`$CommonFactors is.: $CommonFactors"
        $CommonFactors | ForEach-Object { $Numerator = $Numerator / $_; $Denominator = $Denominator / $_ }
    }

    ### Output the results.
    Write-Host -Object "The number '$Number' expressed as a fraction is: $IntegerString$Numerator / $Denominator`n"
    Write-Debug -Message "Error checking: Integer + (Numerator / Denominator) = $( [int64]$( $IntegerString ) + $( $Numerator / $Denominator ) )"
}
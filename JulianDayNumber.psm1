$Colour = [char]27
$BGWhite = "[48;2;255;255;255m"
$FGBlue = "[38;2;1;36;86m"
$ResultTag = "$Colour$BGWhite$Colour$FGBlue"
$Cliyr = "[00m"
$EndResultTag = "$Colour$Cliyr"
function Get-JulianDayNumber () {
	Param (
		[Alias("Y")]
		[int32]$Year,

		[Alias("Mo")]
		[int32]$Mnth,

		[Alias("D")]
		[int32]$Days,

		[Alias("H")]
		[int32]$Hour,

		[Alias("Mi")]
		[int32]$Mins,

		[Alias("S")]
		[int32]$Secs,

		[switch]$Debug,

		[switch]$Split
	)

	# Since the Julian Day starts at noon instead of Midnight, it is necessary to
	# pretend that hours in the A.M are really P.M. from the previous day and
	# that hours in the P.M. are really A.M. of the current day.
	if ($Hour -lt 12) {
		$Hour+=12
		$Days-=1
	}
	elseif ($Hour -ge 12) {
		$Hour-=12
	}
	# It is common to use both 00:00 and 24:00 for Midnight. This flattens it out to 00:00.
	elseif ($Hour -eq 24) {
		$Hour=0
		$Days-=1
	}
	$Hour = ($Hour * 3600)				# Multiply $Hour by 3600 to convert to seconds
	$Mins = ($Mins * 60)				# Multiply $Mins by 60 to convert to seconds
	$FJD = ($Hour + $Mins + $Secs)		# Add together to get total count of seconds
	if ($FJD -gt 0) {
		$FJD = ($FJD / 86400)			# Divide by highest possible number of seconds in a day to convert to decimal
		$FJD = [Math]::Round($FJD, 6)	# Round the result to 6 decimal places. $FJD is the Fractional Julian Day number
	}

	if ($Year -eq 0) {
		Write-Host "Error. There is no year 0 in either C.E. (A.D.) or B.C.E. (B.C.)."
		Return
	}
	# Find out which mode to use, 1 (all years B.C.E.), 2 (C.E. Julian Calendar), or 3 (C.E. Gregorian).
	if ($Year -gt 1582) {
		$Mode=3
	}
	elseif ($Year -eq 1582) {
		if ($Mnth -gt 10) {
			$Mode=3
		}
		elseif ($Mnth -eq 10) {
			if ($Days -gt 14) {
				$Mode=3
			}
			elseif ($Days -lt 5) {
				$Mode=2
			}
			else {
				Write-Host = "Error. The date you entered does not exist. Because Pope."
				Return
			}
		}
		else {
			$Mode=2
		}
	}
	elseif ($Year -lt 1582 -and $Year -gt 0) {
		$Mode=2
	}
	else {
		$Mode=1
	}

	# Find if the entered year is a leap year, accounting for Julian vs. Gregorian rules.
	# This calculation is necessary for the next section, finding the day of the year.
	Switch ($Mode) {
		# Mode 3 = Gregorian Calendar leap year rules.
		# Leap yars occur every 4 years,
		# except if the year is divisible by 100,
		# except they do occur if the year is divisible by 400.
		3 {
			if (($Year % 400) -eq 0)  {
				$LeapDayOffset=1
			}
			else {
				if (($Year % 100) -eq 0) {
					$LeapDayOffset=0
				}
				else {
					if (($Year % 4) -eq 0) {
						$LeapDayOffset=1
					}
					else {
						$LeapDayOffset=0
					}
				}
			}
		}
		# Modes 1 & 2 = Julian Calendar leap year rules.
		# Leap years occur every 4 years. No exceptions.
		{($_ -eq 2) -or ($_ -eq 1)} {
			if (($Year % 4) -eq 0) {
				$LeapDayOffset=1
			}
			else {
				$LeapDayOffset=0
			}
		}
	}

	# Find the day of the year that the given date is.
	# This calculation is necessary for the penulimate step in the algorithms below.
	# The plain number at the end of each line is the number of days elapsed in the year
	# on the final day of the previous month.
	Switch ($Mnth) {
		1 {
			$DayOfYear=$Days
		}
		2 {
			$DayOfYear=$Days+31
		}
		3 {
			$DayOfYear=$Days+$LeapDayOffset+59
		}
		4 {
			$DayOfYear=$Days+$LeapDayOffset+90
		}
		5 {
			$DayOfYear=$Days+$LeapDayOffset+120
		}
		6 {
			$DayOfYear=$Days+$LeapDayOffset+151
		}
		7 {
			$DayOfYear=$Days+$LeapDayOffset+181
		}
		8 {
			$DayOfYear=$Days+$LeapDayOffset+212
		}
		9 {
			$DayOfYear=$Days+$LeapDayOffset+243
		}
		10 {
			$DayOfYear=$Days+$LeapDayOffset+273
		}
		11 {
			$DayOfYear=$Days+$LeapDayOffset+304
		}
		12 {
			$DayOfYear=$Days+$LeapDayOffset+334
		}
	}

	# These are the actual algorithms. They differ slightly depending on which era (Mode) you are in.
	# Mode 1 has to take Negative years into account.
	# Modes 1 and 2 have to take Julian leap year rules into account.
	# Mode 3 has to take Gregorian leap year rules into account.
	Switch ($Mode) {
		1 {
			#$A=4713-$Year		# If B.C.E. dates are entered as positive values.
			$A=4713+$Year		# If B.C.E. dates are entered as negative values.
			$B=$A*365.25
			$C=$B+0.75
			$D=[int][Math]::Truncate($C)
			$E=$DayOfYear-1
			$JDN=$D+$E
		}
		2 {
			$A=$Year-1
			$B=4713+$A
			$C=$B*365.25
			$D=$C+0.75
			$E=[int][Math]::Truncate($D)
			$F=$DayOfYear-1
			$JDN=$E+$F
		}
		3 {
			$A=$Year-1
			$B=4713+$A
			$C=$B*365.25
			$D=$C+0.75
			$E=[int][Math]::Truncate($D)
			$F=$E-10
			$P=(($Year - ($Year % 100))/100)
			if ($P -eq 15) {$G=0}
			else {$G=$P-16}
			$U=($Year % 100)
			$Q=[int][Math]::Truncate($G/4)
			$R=(($G/4)-$Q)
			$I=$G-$Q
			if ($U -eq 0) {
				if ($R -eq 1,2,3) {
					$I-=1
				}
			}
			$J=$F-$I
			$K=$DayOfYear-1
			$JDN=$J+$K
		}
	}

	Write-Host "The Julian Day is: $ResultTag $($JDN+$FJD) $EndResultTag"
	if ($Split) {
		Write-Host
		Write-Host "The Julian Day Number is:     $ResultTag $JDN $EndResultTag"
		Write-Host "The Fractional Julian Day is: $ResultTag $FJD $EndResultTag"
	}

	if ($Debug) {
		Write-Host
		Write-Host "Mode is $Mode"
		Write-Host "A is $A"
		Write-Host "B is $B"
		Write-Host "C is $C"
		Write-Host "D is $D"
		Write-Host "E is $E"
		Write-Host "F is $F"
		Write-Host "P is $P"
		Write-Host "G is $G"
		Write-Host "U is $U"
		Write-Host "Q is $Q"
		Write-Host "R is $R"
		Write-Host "I is $I"
		Write-Host "J is $J"
		Write-Host "K is $K"
		Write-Host "DayOfYear is $DayOfYear"
		Write-Host "LeapDayOffset is $LeapDayOffset"
		Write-Host "Year is $Year"
		Write-Host "Mnth is $Mnth"
		Write-Host "Days is $Days"
		Write-Host "Hour is $Hour"
		Write-Host "Mins is $Mins"
		Write-Host "Secs is $Secs"
	}
}
Set-Alias Get-JDN Get-JulianDayNumber
Set-Alias gjdn Get-JulianDayNumber
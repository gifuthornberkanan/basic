function Start-RouletteSpin() {
    [CmdletBinding()]
    param (
        ### $Bets refer to the numbers that are being bet on.
        [Parameter()]
        [string[]]$Bets = @( "11", "16", "26", "4", "30" ),

        ### $Wagers refer to the amount wagered on each number.
        [Parameter()]
        [int[]]$Wagers = @( 1, 1, 1, 1, 1 ),

        [Parameter()]
        [ValidateRange( 1, 65535 )]
        [int]$Rounds = 1,

        ### If you want to be a cheating cheater who cheats.
        [Parameter()]
        [int]$ForceSpin,

        [Parameter()]
        [string]$Path = "$( $ENV:USERPROFILE )\Documents\WindowsPowerShell\Scripts\fun",

        [Parameter()]
        [string]$File = "bank.txt",

        ### If you want to run a lot of rounds and want to see the extreme points of the bank.
        [Parameter()]
        [switch]$ShowBankHiLo,

        ### If the number of rounds you play is higher than this number, then the function
        ###  won't output a list of all the numbers that hit.
        [Parameter()]
        [int]$WinningNumsToShow = 24

        [Parameter()]
        [switch]$SuppressOutputText
    )

    if ( $Wagers.Count -ne $Bets.Count ) {
        Write-Error -Message "The number of Wagers does not match the number of Bets."
        return
    }

    ### Set up variables
    $Bank = [int]$( Get-Content -Path "$Path\$File" -Raw )
    $StartBank = $Bank
    $LowestBank = $Bank
    $HighestBank = $Bank
    $Wins = 0
    $Loss = 0
    $OutsideBets = @( "col1", "col2", "col3", "1st12", "2nd12", "3rd12", "low", "high", "red", "black", "even", "odd" )
    ### 'corner' and 'square' are different names for the same bet, as are 'sixline' and 'doublestreet'.
    ### 'firstfour' and 'basket' are similar but 'basket' is for boards with a '00'.
    ### These equivalencies will have to be considered when coding these bet algorithms.
    $InsideBets  = @( "split", "street", "corner", "sqaure", "sixline", "doublestreet", "trio", "firstfour", "basket" )
    ### Columns:  0, 00 = 0; 1-34 = 1; 2-35 = 2; 3-36 = 3   Payout:  2 to 1
    ### Dozens:   0, 00 = 0; 1-12 = 1; 2-24 = 2; 3-36 = 3   Payout:  2 to 1
    ### HighLow:  0, 00 = 0; 1-18 = 1; 19-36 = 2            Payout:  1 to 1
    ### RedBlack: 0, 00 = 0; Reds = 1; Blacks = 2           Payout:  1 to 1
    ### OddEven:  0, 00 = 0; Odds = 1; Evens = 2            Payout:  1 to 1
    ### SingleNumber:                                       Payout: 35 to 1
    $AllNumbers = @{
         "0" = @{ Column = "0"; Dozens = "0"; HighLow = "none"; RedBlack = "none";  OddEven = "none" }
         "1" = @{ Column = "1"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "odd"  }
         "2" = @{ Column = "2"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "even" }
         "3" = @{ Column = "3"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "odd"  }
         "4" = @{ Column = "1"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "even" }
         "5" = @{ Column = "2"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "odd"  }
         "6" = @{ Column = "3"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "even" }
         "7" = @{ Column = "1"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "odd"  }
         "8" = @{ Column = "2"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "even" }
         "9" = @{ Column = "3"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "odd"  }
        "10" = @{ Column = "1"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "even" }
        "11" = @{ Column = "2"; Dozens = "1"; HighLow = "low";  RedBlack = "black"; OddEven = "odd"  }
        "12" = @{ Column = "3"; Dozens = "1"; HighLow = "low";  RedBlack = "red";   OddEven = "even" }
        "13" = @{ Column = "1"; Dozens = "2"; HighLow = "low";  RedBlack = "black"; OddEven = "odd"  }
        "14" = @{ Column = "2"; Dozens = "2"; HighLow = "low";  RedBlack = "red";   OddEven = "even" }
        "15" = @{ Column = "3"; Dozens = "2"; HighLow = "low";  RedBlack = "black"; OddEven = "odd"  }
        "16" = @{ Column = "1"; Dozens = "2"; HighLow = "low";  RedBlack = "red";   OddEven = "even" }
        "17" = @{ Column = "2"; Dozens = "2"; HighLow = "low";  RedBlack = "black"; OddEven = "odd"  }
        "18" = @{ Column = "3"; Dozens = "2"; HighLow = "low";  RedBlack = "red";   OddEven = "even" }
        "19" = @{ Column = "1"; Dozens = "2"; HighLow = "high"; RedBlack = "red";   OddEven = "odd"  }
        "20" = @{ Column = "2"; Dozens = "2"; HighLow = "high"; RedBlack = "black"; OddEven = "even" }
        "21" = @{ Column = "3"; Dozens = "2"; HighLow = "high"; RedBlack = "red";   OddEven = "odd"  }
        "22" = @{ Column = "1"; Dozens = "2"; HighLow = "high"; RedBlack = "black"; OddEven = "even" }
        "23" = @{ Column = "2"; Dozens = "2"; HighLow = "high"; RedBlack = "red";   OddEven = "odd"  }
        "24" = @{ Column = "3"; Dozens = "2"; HighLow = "high"; RedBlack = "black"; OddEven = "even" }
        "25" = @{ Column = "1"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "odd"  }
        "26" = @{ Column = "2"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "even" }
        "27" = @{ Column = "3"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "odd"  }
        "28" = @{ Column = "1"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "even" }
        "29" = @{ Column = "2"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "odd"  }
        "30" = @{ Column = "3"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "even" }
        "31" = @{ Column = "1"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "odd"  }
        "32" = @{ Column = "2"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "even" }
        "33" = @{ Column = "3"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "odd"  }
        "34" = @{ Column = "1"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "even" }
        "35" = @{ Column = "2"; Dozens = "3"; HighLow = "high"; RedBlack = "black"; OddEven = "odd"  }
        "36" = @{ Column = "3"; Dozens = "3"; HighLow = "high"; RedBlack = "red";   OddEven = "even" }
        "00" = @{ Column = "0"; Dozens = "0"; HighLow = "none"; RedBlack = "none";  OddEven = "none" }
    }

    foreach ( $Round in 1..$Rounds ) {
        if ( $ForceSpin ) { $Spin = $ForceSpin; $EndNote = "You forced the ball to hit on: " } else { $Spin = $( Get-Random -Maximum 38 -Minimum 0 ); $EndNote = "The ball hit on: " }
        ### Normalize current element of $Bets
        if ( $Spin -eq 37 ) { $Spin = [string]"00" } else { $Spin = [string]$Spin }
        $AllSpins += @($Spin)
        Write-Verbose -Message "`$Spin: $Spin"
        ### If your number hits
        foreach ( $Bet in $Bets ) {
            $CurrentIndex = $Bets.IndexOf( $Bet )
            $CurrentWager = $Wagers[$CurrentIndex]
            Write-Verbose -Message "`CurrentIndex: $CurrentIndex; `$CurrentWager: $CurrentWager; `$Bet: $Bet"
          ### Check for different win scenarios
           ### Check Inside bets
            ### Check Straight bets
            if ( $Spin -eq $Bet ) { $Bank += $( $CurrentWager * 35 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
            Write-Debug -Message "Check Straight Bets --- `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            ### Check Split, Street, Corner/Square, Six Line/Double Street, Trio, First Four (0-1-2-3)/Basket (0-00-1-2-3)
           ### Check Outside bets
            if ( $OutsideBets -contains $Bet ) {
            ### Check Column bets
            if ( @( "col1", "col2", "col3" ) -contains $Bet ) {
                $LandedOn = $Bet.Substring( $( $Bet.Length - 1 ), 1 )
                if ( $AllNumbers.$Spin.Column -eq $LandedOn ) { $Bank += $( $CurrentWager * 2 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
                Write-Debug -Message "Check Column Bets --- `$AllNumbers.$Spin.Column: $( $AllNumbers.$Spin.Column ); `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            }
            ### Check Dozens bets
            if ( @( "1st12", "2nd12", "3rd12" ) -contains $Bet ) {
                $LandedOn = $Bet.Substring( 0, 1 )
                if ( $AllNumbers.$Spin.Dozens -eq $LandedOn ) { $Bank += $( $CurrentWager * 2 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
                Write-Debug -Message "Check Dozens Bets --- `$AllNumbers.$Spin.Dozens: $( $AllNumbers.$Spin.Dozens ); `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            }
            ### Check High-Low bets
            if ( @( "low", "high" ) -contains $Bet ) {
                if ( $AllNumbers.$Spin.HighLow -eq $Bet ) { $Bank += $( $CurrentWager * 1 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
                Write-Debug -Message "Check High-Low Bets --- `$AllNumbers.$Spin.HighLow: $( $AllNumbers.$Spin.HighLow ); `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            }
            ### Check Red-Black bets
            if ( @( "red", "black" ) -contains $Bet ) {
                if ( $AllNumbers.$Spin.RedBlack -eq $Bet ) { $Bank += $( $CurrentWager * 1 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
                Write-Debug -Message "Check Red-Black Bets --- `$AllNumbers.$Spin.RedBlack: $( $AllNumbers.$Spin.RedBlack ); `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            }
            ### Check Odd-Even bets
            if ( @( "odd", "even" ) -contains $Bet ) {
                if ( $AllNumbers.$Spin.OddEven -eq $Bet ) { $Bank += $( $CurrentWager * 1 ); $Wins++ } else { $Bank -= $CurrentWager; $Loss++ }
                Write-Debug -Message "Check Odd-Even Bets --- `$AllNumbers.$Spin.OddEven: $( $AllNumbers.$Spin.OddEven ); `$Spin: $Spin; `$Bet: $Bet; `$Bank: $Bank; `$CurrentWager: $CurrentWager; `$Wins: $Wins; `$Loss: $Loss; `$Round: $Round"
            }
            }
        }
        if     ( $Bank -lt $LowestBank  ) { $LowestBank  = $Bank }
        elseif ( $Bank -gt $HighestBank ) { $HighestBank = $Bank }
    }
    if ( -not $SuppressOutputText ) {
        if ( $Rounds -le $WinningNumsToShow ) {
            Write-Host "$( $EndNote )`[$($color.CandyRed.tbit)$(      $AllSpins | ForEach-Object { "$_".PadLeft( 2, " " ) } )$CL`]."
            Write-Host "Your bet was on: `[$($color.Golden.tbit)$(        $Bets | ForEach-Object { "$_".PadLeft( 2, " " ) } )$CL`]."
            Write-Host "Your wager was:  `[$($color.GlaukosBlue.tbit)$( $Wagers | ForEach-Object { "$_".PadLeft( 2, " " ) } )$CL`].`n"
        }
        Write-Host "You won $( ( $Bank - $StartBank ) ) credits and your bank is now at $([char]0x25cb)$Bank`.`nYou won $Wins times and lost $Loss times."
        if ( $ShowBankHiLo ) {
            Write-Host "Your bank went as high as $HighestBank and as low as $LowestBank."
        }
    }
    $Bank | Out-File -FilePath "$Path\$File" -Force
}

Set-Alias -Name Spin -Value Start-RouletteSpin
function Get-DeckOfCards() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]$HowManyDecks = 1
    )
    $Spades   = @{ Pip = "$([char]0x2660)"; Order = 1; Name = "Spades"   }
    $Hearts   = @{ Pip = "$([char]0x2665)"; Order = 2; Name = "Hearts"   }
    $Clubs    = @{ Pip = "$([char]0x2663)"; Order = 3; Name = "Clubs"    }
    $Diamonds = @{ Pip = "$([char]0x2666)"; Order = 4; Name = "Diamonds" }
    $Suites   = @( $Spades, $Hearts, $Clubs, $Diamonds )
    $Ranks    = @( "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" )

    ### Create unshuffled deck(s)
    Foreach ( $Set in 1..$HowManyDecks ) {
        Foreach ( $Suite in $Suites ) {
            Foreach ( $Rank in $Ranks ) {
                $Deck += @(
                    @{ Face = $($Rank + $Suite.Pip).PadLeft( 3, " " ); Rank = $Rank; Suite = $Suite.Name; RankOrder = $( $Ranks.IndexOf($Rank) + 1 ); SuiteOrder = $Suite.Order }
                )
            }
        }
    }

    ### Give the deck(s) away
    return $Deck
}
Set-Alias -Name GetDeck -Value Get-DeckOfCards

function Get-ShuffledDeckOfCards() {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true )]
        [Alias( "Deck" )]
        [hashtable[]]$PreShuffledDeck
    )

    ### Shuffle the deck(s)
    $ShuffledDeck = $PreShuffledDeck | Sort-Object { Get-Random }

    ### Give the deck(s) away
    return $Deck = $ShuffledDeck
}
Set-Alias -Name ShuffleDeck -Value Get-ShuffledDeckOfCards

function New-DealedDeckOfCards() {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true )]
        [int]$HowManyToDeal,

        [Parameter( Mandatory = $true )]
        [hashtable[]]$Deck,

        [Parameter()]
        [hashtable[]]$Hand
    )

    ### Get each card out of the deck and into the hand
    Foreach ( $Card in 0..( $HowManyToDeal - 1) ) {
        $Hand += @( $Deck[$Card] )
    }

    ### Remove the dealt cards from the deck
    Foreach ( $Card in 1..$HowManyToDeal ) {
        $Deck = $Deck[1..( $Deck.Length-1 )]
    }

    return $Deck, $Hand
    ### Can be set like this:
    ### $deck, $hand = New-DealedDeckOfCards -HowManyToDeal 3 -Deck $deck -Hand $hand
}
Set-Alias -Name DealHand -Value New-DealedDeckOfCards

function Show-DeckOfCards() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias( "Hand" )]
        [hashtable[]]$Deck
    )

    $WindowWidth = $Host.UI.RawUI.WindowSize.Width
    $MaxCardsDisplayed = [math]::Truncate($WindowWidth / 5)

    Foreach ( $Card in $Deck ) {
        if ( ( $Card.SuiteOrder -eq 1 ) -or ( $Card.SuiteOrder -eq 3) ) {
            $Coloring = "$BG$($color.Canvas.tbit)$FG$($color.Charcoal.tbit)"
        } else {
            $Coloring = "$BG$($color.Canvas.tbit)$FG$($color.CandyRed.tbit)"
        }

        $line1 += "$BG$($color.Canvas.tbit)    $CL "
        $line2 += "$Coloring$($Card.Face) $CL "

        $Counter++
        if ( ( $Counter -eq $MaxCardsDisplayed ) -or ( $Counter -eq $Deck.Count ) ) {
            Write-Host "$line1"
            Write-Host "$line2"
            Write-Host "$line1"
            Write-Host " "
            $line1 = ""
            $line2 = ""
        }
    }
}
Set-Alias -Name SeeDeck -Value Show-DeckOfCards
class CustomColor {
    [String]$Name = "<Empty>"
    [Long]$colorID = 0
    [Long]$hueOrder = 0
    [Int]$r = 0
    [Int]$g = 0
    [Int]$b = 0
    [Double]$h = 0
    [Double]$s = 0
    [Double]$l = 0
    [String]$PrimaryGroup = "<Empty>"
    [String]$SecondaryGroup = "<Empty>"
    [String]$TertiaryGroup = "<Empty>"
    [String]$Notes = "<Empty>"
    [String]tbit(){return ("2;$($this.r);$($this.g);$($this.b)m")}
    [String]ebit(){return ("5;$($this.colorID)m")}
    [String]ToHexString(){return ("#$("{0:x2}" -f $this.r)$("{0:x2}" -f $this.g)$("{0:x2}" -f $this.b)")}
    [Boolean]isXterm(){if ($this.colorID -le 255) {return $true} else {return $false}}
    [String]FG([String]$strInput){return ("$([char]27)[38;$($this.tbit())$strInput$([char]27)[00m")}
    [String]BG([String]$strInput){return ("$([char]27)[48;$($this.tbit())$strInput$([char]27)[00m")}
    [String]Colorize([CustomColor]$BackGr, [CustomColor]$ForeGr, [String]$strInput){return ("$([char]27)[48;$($BackGr.tbit())$([char]27)[38;$($ForeGr.tbit())$strInput$([char]27)[00m")}
}

[CustomColor]$MyReed = [CustomColor]::new()
$MyReed.r = 255
$MyReed.g = 10
$MyReed.b = 10
$MyReed.PrimaryGroup = "Reds"
$MyReed.SecondaryGroup = "Reds"
$MyReed.TertiaryGroup = "Reds"
$MyReed.colorID = "666"
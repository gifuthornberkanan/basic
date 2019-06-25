class Color {
    [Int]$r = 0
    [Int]$g = 0
    [Int]$b = 0
    [Double]$h = 0
    [Double]$s = 0
    [Double]$l = 0
    [String]$X11Name = "<Empty>"
    [Long]$colorID = 0
    [Long]$hueOrder = 0
    [Boolean]$isXterm = $false
    [String]$PrimaryGroup = "<Empty>"
    [String]$SecondaryGroup = "<Empty>"
    [String]$TertiaryGroup = "<Empty>"
    [String]$Notes = "<Empty>"
    [String]tbit(){return ("2;$($this.r);$($this.g);$($this.b)m")}
    [String]ebit(){return ("5;$($this.X11Number)m")}
    [String]ToHexString(){return ("#$("{0:x2}" -f $this.r)$("{0:x2}" -f $this.g)$("{0:x2}" -f $this.b)")}
}

class ColorContainer {
    [Color[]]$Colors
}
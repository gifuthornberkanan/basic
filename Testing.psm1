function New-Testing () {
    Param (
        [Parameter(ParameterSetName="Joined")]
        [string[]]$Ports,

        [Parameter(ParameterSetName="Separated")]
        [string[]]$TCP,

        [Parameter(ParameterSetName="Separated")]
        [string[]]$UDP
    )

    # If you choose to enter the items in separate lists, then string them together
    # in the form "tcp/443" so that they get passed to the next section in the same
    # form as if they were entered in the syntax of the single list. The third value
    # will be used later in sorting so that TCP and UDP ports of the same number are
    # next to each other but the TCP one will appear first.
    Switch ($PSCmdlet.ParameterSetName) {
        "Separated" {
            ForEach ($Port in $TCP) {
                $Ports += "tcp/$Port/1"
            }
            ForEach ($Port in $UDP) {
                $Ports += "udp/$Port/2"
            }
        }
        "Joined" {
            $SplitPorts = $($Ports.Split(' '))
            $Ports = $null
            ForEach ($Port in $SplitPorts) {
                if ($Port -like "tcp*") {$Port += '/1'}
                elseif ($Port -like "udp*") {$Port += '/2'}
                $Ports += $Port
            }
        }
    }
    # Define AllServicePortPairs hashtable that will hold ServiceName/Port pairs sub-hashes.
    $AllServicePortPairs = @{}
    # Go through every ServiceName/Port pair.
    $Ports | ForEach-Object {
        # Split the pair into separate parts of an array.
        $ThisServicePortPair = $($_.Split('/'))
        # Increment a counter.
        $NumberOfPorts += 1
        # Populate the hashtable with Key/Value pairs of ServiceName, Port and Order respectively.
        $AllServicePortPairs.Add(($NumberOfPorts),(@{
            "Service" = $ThisServicePortPair[0]
            "Port" = $ThisServicePortPair[1]
            "Order" = $ThisServicePortPair[1] + $ThisServicePortPair[2]
        }))
    }

    # Sort the hash values by port so that TCP and UDP ports of the same number
    # are next to each other.
    # Go through each sub-hash one at a time.
    ForEach ($k in 1..$AllServicePortPairs.Count) {
        # Compare it to every other sub-hash.
        ForEach ($j in 1..$AllServicePortPairs.Count) {
            # If the sub-hash in question is smaller than the one it is
            # being compared to, then swap them. I'm not sure why this
            # works. It seems like it should be "-gt" but that sorts
            # them in the reverse order for some reason.
            if ($($AllServicePortPairs.$k.Order - $AllServicePortPairs.$j.Order) -lt 0) {
                $Swap = $AllServicePortPairs.$k
                $AllServicePortPairs.$k = $AllServicePortPairs.$j
                $AllServicePortPairs.$j = $Swap
            }
        }
    }

    # KVPair is just an index here but it works with how the hashtable was structured.
    # Output a message using values from the hashtable. The 'i' variable was set above.
    ForEach ($KVPair in 1..$NumberOfPorts) {
        Write-Host "Service is: $($AllServicePortPairs.$KVPair.Service), Port is: $($AllServicePortPairs.$KVPair.Port), Order is: $($AllServicePortPairs.$KVPair.Order)."
    }
}
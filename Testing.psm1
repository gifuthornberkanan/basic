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
    # form as if they were entered in the syntax of the single list.
    if ($PSCmdlet.ParameterSetName -eq "Separated") {
        ForEach ($Port in $TCP) {
            $Ports += "tcp/$Port"
        }
        ForEach ($Port in $UDP) {
            $Ports += "udp/$Port"
        }
    }
    # Define ServicePort hashtable that will hold ServiceName/Port pairs.
    $ServicePort = @{}
    # Go through every ServiceName/Port pair.
    $Ports | ForEach-Object {
        # Split the pair into separate parts of an array.
        $Services = $($_.Split('/'))
        # Increment a counter.
        $i += 1
        # Populate the hashtable with Key/Value pairs of ServiceName and Port, respectively.
        $ServicePort.Add(($i),(@{
            "Service" = $Services[0]
            "Port" = $Services[1]
        }))
    }

    # In this spot I would eventually like to sort the hash values by port
    # so that TCP and UDP ports of the same number are nex to each other.

    # KVPair is just an index here but it works with how the hashtable was structured.
    # Output a message using values from the hashtable. The 'i' variable was set above.
    ForEach ($KVPair in 1..$i) {
        Write-Host "Service is: $($ServicePort.$KVPair.Service), Port is: $($ServicePort.$KVPair.Port)."
    }
}
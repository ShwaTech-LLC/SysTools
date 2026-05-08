param(
    [Parameter(ParameterSetName="Host")]
    [switch]$HostMode,
    [ValidateRange(1,134217728)]
    [int]$PayloadBytes = 65535,
    [Parameter(ParameterSetName="Target")]
    [string]$Target,
    [ValidateRange(10000,65000)]
    [int]$Port = 12333,
    [ValidateRange(1024,134217728)]
    [int]$ReceiveBufferSize = 65535
)

# Define the constants for measuring throughput and creating buffers
[UInt64]$oneKilobyte = 1024
[UInt64]$oneMegabyte = $oneKilobyte * 1024
[UInt64]$oneGigabyte = $oneMegabyte * 1024

# Declare the counters for measuring throughput
[UInt64]$pings = 0
[UInt64]$bytesSent = 0
[UInt64]$bytesReceived = 0

# Setup script-level variables for reporting timing
$totalDataFormatted = ""
$startTime = Get-Date

# Create a receive buffer used by the host or client
$bufferIn = [Array]::CreateInstance( [byte], $ReceiveBufferSize )

# Check the host mode flag and run in host mode or client mode
if( $HostMode ) {

    # Create a random array of data to send to the client for download-optimized mode
    $random = [Array]::CreateInstance( [byte], $PayloadBytes )

    # Start the listener on the desired port
    "Awaiting TCP client on port $Port"
    $endpoint = New-Object -TypeName "System.Net.IPEndPoint" -ArgumentList @( [IPAddress]::Any, $Port )
    $listener = New-Object -TypeName "System.Net.Sockets.TcpListener" -ArgumentList $endpoint
    $listener.Start()

    # Accept the first client that connects and initiate the test
    $data = $listener.AcceptTcpClient()
    "Client connected"

    # Fetch the network stream from the connection
    $stream = $data.GetStream()

    # Mark the start time of the test to begin after overhead actions
    "Test started at $(Get-Date)"
    $startTime = Get-Date

    # Read the client data and send back the random data payload until the connection is closed by force
    while( ($stream.Socket.Connected) ) {

        # Setup the handshake counter to wait for the incoming data payload from the client
        $handshake = 0
        $dataRead = 0

        # Wait for the client to send all data
        do {
            if( $stream.DataAvailable ) {
                $dataRead = $stream.Read( $bufferIn, 0, ($bufferIn.Length) )
            } else {
                $dataRead = 0
            }
            $bytesReceived += $dataRead
            $handshake += $dataRead
        } while( ($dataRead -gt 0) -or ($handshake -eq 0) )
        
        # Write back the data payload
        $stream.Write( $random, 0, ($random.Length) )
        
        # Increment the number of exchanges and amount of data sent
        $pings += 1
        $bytesSent += ($random.Length)
    }

    # Clean up the stream resources
    $stream.Close()
    $listener.Stop()

} else {

    # Create a random array of data to send as the client to the host
    $random = [Array]::CreateInstance( [byte], $PayloadBytes )

    # Make the connection to the target host
    "Connecting to host"
    $client = New-Object -TypeName "System.Net.Sockets.TcpClient" -ArgumentList @( $Target, $Port )
    $stream = $client.GetStream()

    # Mark the testing start time
    "Test started at $(Get-Date)"
    $startTime = Get-Date

    # Send the payload to the host
    "Write to host"
    $stream.Write( $random, 0, ($random.Length) )
    $bytesSent += ($random.Length)

    # Read data from the host until the connection is closed by force
    while( ($stream.Socket.Connected) ) {

        # Setup the handshake counter to wait for the data payload from the host
        $handshake = 0
        $dataRead = 0

        # Read all bytes from the host into the read buffer
        do {
            if( $stream.DataAvailable ) {
                $dataRead = $stream.Read( $bufferIn, 0, ($bufferIn.Length) )
            } else {
                $dataRead = 0
            }
            $bytesReceived += $dataRead
            $handshake += $dataRead
        } while( ($dataRead -gt 0) -or ($handshake -eq 0) )
        
        # Send the response back to the host
        $stream.Write( $random, 0, ($random.Length) )
        $bytesSent += ($random.Length)

        # Increment the counters and calculate throughput
        $pings += 1
        $totalBytes = ($bytesSent + $bytesReceived)
        $totalSeconds = ((Get-Date) - $startTime).TotalSeconds
        $mbps = $totalBytes / 8 / $totalSeconds / $oneMegabyte
        $totalMegabytes = $totalBytes / $oneMegabyte
        $totalGigabytes = $totalBytes / $oneGigabyte

        # Report the throughput on the console
        if( $totalMegabytes -gt 100 ) {
            $totalDataFormatted = "Total data: $($totalGigabytes.ToString("0.00")) GB"
        } else {
            $totalDataFormatted = "Total data: $($totalMegabytes.ToString("0.00")) MB"
        }
        Write-Progress -Activity "Testing network stability" -Status "Successful pings: $pings, $totalDataFormatted, Throughput: $($mbps.ToString("0.00")) mbps"
    }

    # Cleanup the stream resources
    $stream.Close()
}

# Report the statistics of the session when it ends
$endTime = Get-Date
"Test ended at $(Get-Date)"
$duration = $endTime - $startTime
"Total pings: $pings"
"Total seconds before failure: $($duration.TotalSeconds)"
"Total minutes before failure: $($duration.TotalMinutes)"
"Bytes sent: $bytesSent"
"Bytes receieved: $bytesReceived"
"Total bytes: $($bytesSent + $bytesReceived)"
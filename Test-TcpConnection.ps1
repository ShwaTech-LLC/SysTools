param(
    [string]$Data,
    [switch]$Quiet,
    [Parameter(ParameterSetName="Host")]
    [switch]$HostMode,
    [Parameter(ParameterSetName="Target")]
    [string]$Target,
    [ValidateRange(1,65535)]
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
    $payload = [Array]::CreateInstance( [byte], 1 )
    if( $Data ) {
        $payload = [System.Text.Encoding]::ASCII.GetBytes( $Data )
    } else {
        $payload[0] = 0
    }

    # Make the connection to the target host
    $client = New-Object -TypeName "System.Net.Sockets.TcpClient" -ArgumentList @( $Target, $Port )
    $stream = $client.GetStream()

    # Do not send an initial payload if Quiet was specified
    if( $Quiet ) {
        $stream.Write( $payload, 0, ($payload.Length) )
        $stream.Flush()
    }

    # Read the response from the host
    $bytesRead = $stream.Read( $bufferIn, 0, ($bufferIn.Length) )
    [System.Text.Encoding]::ASCII.GetString( $bufferIn, 0, $bytesRead )
}

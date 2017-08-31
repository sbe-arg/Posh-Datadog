<#
.SYNOPSIS
	Send metrics to statsd server using a sigle standalone function.
  You can send event, metric or checks by passing the correct $data text string to this function
.DESCRIPTION
	PowerShell cmdlet to send metric data to statsd server. Unless IP or port is passed, tries the default IP of 127.0.0.1 and port of 8125.
.PARAMETER data
	Metric data to send to statsd. If string is not enclosed in quotes (single or double), the pipe character needs to be escaped.
.PARAMETER ip
	IP address for statsd server
.PARAMETER port
	Port that statsd server is listening to
.EXAMPLE
  METRICS
  Send-DatadogStatsD 'my_metric:321|g'
  Send-DatadogStatsD 'iis.net.bytes_rcvd:0|g|@1|#Testing,listset:web.service,instance:_total'
  Send-DatadogStatsD '.net.clr.memory_large.object.heap.size:1.32613E+07|g|@1|#.NET,listset:.net.clr.memory,instance:_global_'

  EVENT
  Send-DatadogStatsD '_e{10,09}:test title|test text'
  Send-DatadogStatsD '_e{10,09}:test title|test text|#tag1:value,tag2'

  SERVICE CHECK
  note adding #tags to _sc doesn't seem to work.
  if you create a check make sure to also send events about it or they don't create anything on the events view only the checks/monitor view.
  Send-DatadogStatsD '_sc|testcheckname|0|m:test check packet omg its ok'
  Send-DatadogStatsD '_sc|testcheckname|2|m:test check packet omg its critical'
#>

function Send-DatadogStatsD {
	Param(
	  [parameter(Mandatory=$true, ValueFromPipeline=$true)]
	  [string]$data,

	  [parameter(Mandatory=$false, ValueFromPipeline=$true)]
	  [string]$ip = "127.0.0.1",

	  [parameter(Mandatory=$false, ValueFromPipeline=$true)]
	  [int]$port= "8125"
	)
  begin{
    $testipport = (Test-NetConnection $ip -Port $port).TcpTestSucceeded
    if($testipport -eq $false){
      Write-Warning "Can't connect to $ip port $port. Check your network or input values and try again."
      break
    }
  }
  process{
  	$ipAddress = [System.Net.IPAddress]::Parse($ip)

  	# Create endpoint and udp client
  	$endPoint = New-Object System.Net.IPEndPoint($ipAddress, $port)
  	$udpclient = New-Object System.Net.Sockets.UdpClient

  	# Encode and send the data
  	$encodedData = [System.Text.Encoding]::ASCII.GetBytes($data)
  	$bytesSent = $udpclient.Send($encodedData,$encodedData.length,$endPoint)
  	Write-Warning "Sent $bytesSent to $ipAddress $port with payload of: $data"

  	# Cleanup after yourself
  	$udpclient.Close()
  }
}

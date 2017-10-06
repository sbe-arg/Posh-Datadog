<#
.SYNOPSIS
    Connect to Datadog API and silence hosts
.DESCRIPTION
    Default time is Last 30 min
.EXAMPLE
    Invoke-DatadogSilencing -Scope "value" -For 3600 #seconds
#>

function Invoke-DatadogSilencing {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [string]$Scope,
      [int]$For = "1800"
  )

    $time = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds # current time
    $till_time = ($time + $For)

    $urlbase = "https://app.datadoghq.com/api/v1/downtime"

    [hashtable]$body = @{}
    $body.scope = $scope
    $body.start = $time
    $body.end = $till_time

    $bodyjson = $body | convertto-json
    $url = $urlbase + "?api_key=$Api_Key" + "&" + "application_key=$App_Key"
    $results = Invoke-RestMethod -Uri $url -Body $bodyjson -ContentType application/json -Method Post -UseBasicParsing
    $results
}

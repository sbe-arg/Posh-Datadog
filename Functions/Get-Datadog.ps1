<#
.SYNOPSIS
    Connect to Datadog API and get events info
.DESCRIPTION
    Default time is Last 30 minutes
.EXAMPLE
    Get-Datadog -Filter valuefromtextinmonitor -Tags "tag1:value1" -Sources "alert,datadog" -Time [int]inseconds
#>

function Get-Datadog {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [string]$Filter,
      [string]$Tags,
      [string]$Sources,
      [int]$Last = "1800"
  )

    $time = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds # current time
    $start_time = ($time - $Last) # ~1h ago

    $urlbase = "https://app.datadoghq.com/api/v1/events"

    $url = $urlbase + "?api_key=$Api_Key" + "&" + "application_key=$App_Key" + "&" + "start=$start_time" + "&" + "end=$time" + "&" + "sources=$Sources" + "&" + "tags=$Tags"
    $results = Invoke-RestMethod -Uri $url -Method Get -UseBasicParsing
    $results = $results | Select-Object -ExpandProperty events | Where-Object {$_.text -like "*$Filter*"}
    $results
}

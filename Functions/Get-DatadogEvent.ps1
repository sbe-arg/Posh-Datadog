<#
.SYNOPSIS
    Connect to Datadog API and get events info
.DESCRIPTION
    Default time is Last 30 minutes
.EXAMPLE
    Get-DatadogEvent -Filter "from-text-in-monitor" -Tags "tag1:value1" -Sources "alert,datadog" -Time [int]inseconds
#>

function Get-DatadogEvent {
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
    $start_time = ($time - $Last)

    $urlbase = "https://app.datadoghq.com/api/v1/events"

    if(! $tags){
      $url = $urlbase + "?api_key=$Api_Key" + "&" + "application_key=$App_Key" + "&" + "start=$start_time" + "&" + "end=$time" + "&" + "sources=$Sources"
    }
    else{
      $url = $urlbase + "?api_key=$Api_Key" + "&" + "application_key=$App_Key" + "&" + "start=$start_time" + "&" + "end=$time" + "&" + "sources=$Sources" + "&" + "tags=$Tags"
    }
    $results = Invoke-RestMethod -Uri $url -Method Get -UseBasicParsing
    $results = $results | Select-Object -ExpandProperty events | Where-Object {$_.title -like "*$Filter*"}
    $results
}

<#
.SYNOPSIS
    Connect to Datadog API and send single metric via powershell.
.DESCRIPTION
    Send single gauge metric to datadog.
.EXAMPLE
    Send-DatadogMetric -Metric "cool.beans.success" -Value "20"
#>

function Send-DatadogMetric {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,

      [Parameter(Mandatory=$true)]
      [string]$Metric,

      [Parameter(Mandatory=$true)]
      [int]$Value,

      [ValidateSet("gauge")] # other metrics types are not available via API according to https://help.datadoghq.com/hc/en-us/articles/206955236-Metric-types-in-Datadog
      [string]$Type = "gauge"

  )
    $CurrentTime = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds # current time
    $convertfromepoch = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($CurrentTime))
    Write-Warning "Sending Metric:$Metric Value:$Value Time:$CurrentTime to DD at $convertfromepoch"
    $Body = @"
    {
      "series":
      [
        { "metric": "$Metric",
          "points": [[$CurrentTime, $Value]],
          "type": "$Type"
        }
      ]
    }
"@
    $url = "https://app.datadoghq.com/api/v1/series?api_key=$env:Datadog_API_Key"

    $results = Invoke-RestMethod -Uri $url -Body $Body -Method Post -ContentType application/json
    $results

}

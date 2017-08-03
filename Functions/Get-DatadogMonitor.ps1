<#
.SYNOPSIS
    Connect to Datadog API pull monitors
.DESCRIPTION
    Get monitors from datadog
.EXAMPLE
    Get-DatadogMonitor -MonitorId "idhere"
    Get-DatadogMonitor -Filter "text here"
#>

function Get-DatadogMonitor {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [string]$MonitorId,
      [string]$Filter,
      [switch]$Backup

  )
    if(-NOT $MonitorId){
      $url = "https://app.datadoghq.com/api/v1/monitor?api_key=$env:Datadog_API_Key&application_key=$env:Datadog_APP_Key"
    }
    else{
      $url = "https://app.datadoghq.com/api/v1/monitor/$($MonitorId)?api_key=$env:Datadog_API_Key&application_key=$env:Datadog_APP_Key"
    }

    $results = Invoke-RestMethod -Uri $url -Method Get
    if(-NOT $Filter){
      $results
    }
    else{
      $results | where {$_.Name -like "*$Filter*"}
    }

    if($Backup){
      $folder = Read-Host = "Destination folder"
      foreach ($r in $results){$r | ConvertTo-Json | Out-File -FilePath $folder\$($r.id).json}
    }

}

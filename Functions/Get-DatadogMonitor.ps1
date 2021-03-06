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
      $url = "https://app.datadoghq.com/api/v1/monitor?api_key=$Api_Key&application_key=$App_Key"
    }
    else{
      $url = "https://app.datadoghq.com/api/v1/monitor/$($MonitorId)`?api_key=$Api_Key&application_key=$App_Key"
    }

    $results = Invoke-RestMethod -Uri $url -Method Get
    if(-NOT $Filter){
      $results
    }
    else{
      $results = $results | Where-Object {$_.Name -like "*$Filter*"}
      $results
    }

    if($Backup){
      $folder = Read-Host = "Destination folder"
      if((test-path $folder) -eq $false){
        Write-Warning "$folder path not found."
        break
      }
      else{
        foreach ($r in $results){
          $r | ConvertTo-Json -depth 10 | Out-File -FilePath $folder\$($r.id).json -Encoding ascii -Verbose
        }
      }
    }

}

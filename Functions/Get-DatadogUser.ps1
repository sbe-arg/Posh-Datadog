<#
.SYNOPSIS
    Connect to Datadog API pull users
.DESCRIPTION
    Get users from datadog
.EXAMPLE
    Get-DatadogUser -Filter "valuehere"
    Get-DatadogUser -Backup
#>

function Get-DatadogUser {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [string]$Filter,
      [switch]$Backup
  )

    $url = "https://app.datadoghq.com/api/v1/user?api_key=$Api_Key&application_key=$App_Key"

    $results = Invoke-RestMethod -Uri $url -Method Get
    if(-NOT $Filter){
      $results
    }
    else{
      $results = $results | select -expandproperty * | where {$_.Handle -like "*$Filter*"}
      $results
    }

    if($Backup){
      $folder = Read-Host = "Destination folder"
      foreach ($r in $results){$r | ConvertTo-Json | Out-File -FilePath $folder\$($r.id).json}
    }

}

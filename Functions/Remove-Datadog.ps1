<#
.SYNOPSIS
    Connect to Datadog API and remove events
.DESCRIPTION
    Remove events to datadog
.EXAMPLE
    Remove-Datadogevent -EventId "idhere"
#>

function Remove-DataDogEvent {
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [string]$EventId

  )

    $url = "https://app.datadoghq.com/api/v1/events/$($EventId)?api_key=$env:Datadog_API_Key&application_key=$env:Datadog_APP_Key"

    Invoke-RestMethod -Uri $url -Method Delete

}

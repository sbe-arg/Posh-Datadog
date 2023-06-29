<#
.SYNOPSIS
    Connect to Datadog API and send to the event stream
.DESCRIPTION
    Send events to datadog
.EXAMPLE
    $Tags = @("tag1:value1","tag2:value2","tag3:value3") | ConvertTo-Json
    Send-DatadogEvent -Title "my title" -Message "this is an event content" -Tags $Tags
#>

function Send-DatadogEvent {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Api_Key = $env:Datadog_API_Key,
        [string]$Title,
        [string]$Message,
        [ValidateSet("Normal", "Low")]
        [string]$Priority = "Normal",
        [string]$Tags = "`"created-by:powershell.posh-datadog`"", # needs a default tag if no -tags $tags specified
        [ValidateSet("Error", "Warning", "Success", "Info")]
        [string]$Type = "Info"
    )
    Write-Warning "Sending $Priority priority $Type Event:$Title Message:$Message"
    $Body = @"
    {
          "title": "$Title",
          "text": "$Message",
          "priority": "$Priority",
          "tags": $Tags,
          "alert_type": "$Type"
       }
"@

    $url = "https://app.datadoghq.com/api/v1/events?api_key=$Api_Key"

    # debug
    # $jsonObject = $Body | ConvertFrom-Json

    $results = Invoke-RestMethod -Uri $url -Body $Body -Method Post -ContentType application/json
    $results
}

# Posh-Datadog
Hand commands for Datadog event management.

# To test:
Download module -> run Posh-Datadog.sandbox.ps1 to load.

```powershell
# Query events stream:
Get-DatadogEvent -Filter "from-text-in-monitor" -Tags "tag1:value1" -Sources "alert" -Time [int]inseconds
# Remove Event:
Remove-DatadogEvent -EventId "eventidhere"
# Send events:
Send-DatadogEvent -Title "my title" -Message "this is an event content" -Tags $Tags
```


# Open Source:
I have no affiliation with Datadog, take a copy and do whatever :)

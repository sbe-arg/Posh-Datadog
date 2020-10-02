# Posh-Datadog module

[![Build status](https://ci.appveyor.com/api/projects/status/cilr6ssa6agsm0ct?svg=true)](https://ci.appveyor.com/project/sbe-arg/posh-datadog)

## To test/debug:

Download module -> run Posh-Datadog.sandbox.ps1 to load.

## Install via PowershellLibrary

```powershell
PowerShellGet\Install-Module Posh-Datadog -Scope CurrentUser
```

### Or install/update via PsGet

```powershell
psget\Install-Module -ModuleUrl https://github.com/sbe-arg/Posh-Datadog/archive/master.zip # -update
```

## cmdlets

```powershell
# Query events stream:
Get-DatadogEvent -Filter "from-text-in-monitor" -Tags "tag1:value1" -Sources "alert" -Time [int]inseconds
# Remove Event:
Remove-DatadogEvent -EventId "eventidhere"
# Send events:
Send-DatadogEvent -Title "my title" -Message "this is an event content" -Tags $Tags
Send-DatadogStatsD '_e{10,09}:test title|test text|#tag1:value,tag2'
# Query monitors:
Get-DatadogMonitor -MonitorId "idhere"
Get-DatadogMonitor -Filter "this is a monitor name/title"
Get-DatadogMonitor -Backup # saves a copy on $folder of selected monitors in json for easy restore
# Query users:
Get-DatadogUser -Filter "valuehere"
Get-DatadogUser -Backup
# Edit datadog users with a lot of carefull here
Set-DatadogUser -User "fullemailhere"
Set-DatadogUser -SetRole "adm,ro,st"
Set-DatadogUser -SetName "sting"
Set-DatadogUser -SetEmail "string"
# Metrics:
$Tags = @("creator:$env:USERNAME","host:$env:COMPUTERNAME") | ConvertTo-JSON
Send-DatadogMetric -Metric "cool.beans.success" -Value "20" -Tags $Tags
# or
Send-DatadogMetric -Metric "cool.beans.success" -Value "20" -Tags "[`"creator:$env:USERNAME`",`"host:$env:COMPUTERNAME`"]"

Send-DatadogStatsD 'my_metric:321|g'
```

# Open Source:

I have no affiliation with Datadog, take a copy and do whatever :)

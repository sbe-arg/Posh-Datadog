# Posh-Datadog
Hand commands for Datadog event management.

# To test/debug:
Download module -> run Posh-Datadog.sandbox.ps1 to load.

### Step One: Install psget
```powershell
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
```


### Step Two: Install Posh-Datadog
```powershell
psget\Install-Module -ModuleUrl https://github.com/sbe-arg/Posh-Datadog/archive/master.zip
```

## Upgrading
From time-to-time *Posh-Datadog* will be updated to include new features.
To update *Posh-Datadog*, execute the following:
```powershell
psget\Install-Module -ModuleUrl https://github.com/sbe-arg/Posh-Datadog/archive/master.zip -Update
```

## Some cmdlets
```powershell
# Query events stream:
Get-DatadogEvent -Filter "from-text-in-monitor" -Tags "tag1:value1" -Sources "alert" -Time [int]inseconds
# Remove Event:
Remove-DatadogEvent -EventId "eventidhere"
# Send events:
Send-DatadogEvent -Title "my title" -Message "this is an event content" -Tags $Tags
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
```


# Open Source:
I have no affiliation with Datadog, take a copy and do whatever :)

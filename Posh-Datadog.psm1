Write-Verbose "Posh-Datadog module"
Write-Verbose 'Doing stuff...'

# load functions
  $functionFilter = Join-Path $PSScriptRoot "Functions"
  Get-ChildItem -Path $functionFilter -Filter "*.ps1" -Recurse |
  Foreach-Object {
      Write-Verbose "Loading function $($_.Name).."
      . $_.FullName
  }

  if(-not $env:Datadog_API_Key){
      Write-Warning "Cannot find Datadog API Key on this system."
      Write-Warning 'We will save it as $env:Datadog_API_Key'
      $storekey = Read-Host "Enter your Datadog API Key"
      [Environment]::SetEnvironmentVariable("Datadog_API_Key", "$storekey", "User")
  }
  if(-not $env:Datadog_APP_Key){
      Write-Warning "Cannot find Datadog App Key on this system."
      Write-Warning 'We will save it as $env:Datadog_APP_Key'
      $storeapp = Read-Host "Enter an Datadog App Key"
      [Environment]::SetEnvironmentVariable("Datadog_APP_Key", "$storeapp", "User")
  }

Write-Verbose 'Done!'

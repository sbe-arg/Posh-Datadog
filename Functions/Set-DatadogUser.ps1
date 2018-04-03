<#
.SYNOPSIS
    Connect to Datadog API edit users
.DESCRIPTION
    Edit users from datadog
.EXAMPLE
    Set-DatadogUser -User "fullemailhere"
    Set-DatadogUser -SetRole "adm"
    Set-DatadogUser -SetName "sting"
    Set-DatadogUser -SetEmail "string"
#>

function Set-DatadogUser {
  [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
  param(
      [Parameter(Mandatory=$false)]
      [string]$Api_Key = $env:Datadog_API_Key,
      [string]$App_Key = $env:Datadog_APP_Key,
      [Parameter(Mandatory=$true)]
      [string]$User,
      [ValidateSet("adm","st","ro")]
      [string]$SetRole,
      [string]$SetName,
      [string]$SetEmail


  )
    $Values = New-Object System.Collections.Generic.List[System.Object]
    if($SetName){
      if(-NOT $SetRole -and -NOT $SetEmail){
        $Name = "`"name`": `"$SetName`""
        $Values.add($Name)
      }else{
        $Name = "`"name`": `"$SetName`",`n"
        $Values.add($Name)
      }
    }
    if($SetEmail){
      if(-NOT $SetRole){
        $Email = "`"email`": `"$SetEmail`""
        $Values.add($Email)
      }else{
        $Email = "`"email`": `"$SetEmail`",`n"
        $Values.add($Email)
      }
    }
    if($SetRole){
      $Role = "`"access_role`": `"$SetRole`""
      $Values.add($Role)
    }

    Get-DatadogUser -Filter $User
    # $Body = "{`n$Values`n}" | ConvertFrom-Json | ConvertTo-Json

    $url = "https://app.datadoghq.com/api/v1/user/$($User)?api_key=$Api_Key&application_key=$App_Key"

    # -whatif?
    if($pscmdlet.ShouldProcess($user)) {
      $results = Invoke-RestMethod -Uri $url -Method Put
      $results
    }

}

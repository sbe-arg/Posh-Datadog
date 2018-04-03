Clear-Host
Remove-Module Posh-Datadog -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot -Verbose
cd $PSScriptRoot
Get-Module PSScriptAnalyzer

Write-Warning "Running tests..."
$checks = Get-ChildItem .\Tests\Module\*.ps1
foreach($check in $checks){
    & $check.FullName
}

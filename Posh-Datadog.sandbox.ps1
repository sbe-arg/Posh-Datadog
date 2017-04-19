Clear-Host
Remove-Module Posh-Datadog -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot -Verbose
cd $PSScriptRoot
Get-Module PSScriptAnalyzer

# script analyze functions?
$questionsa = Read-Host "Run ScriptAnalylzer checks? (yes/no)"
if($questionsa -like "y*"){
    $functionFilter = Join-Path $PSScriptRoot "Functions"
    $functions = Get-ChildItem -Path $functionFilter -Filter "*.ps1" -Recurse
    Foreach($f in $functions) {
        Write-Output "Analyzing function $($f.FullName)"
        Invoke-ScriptAnalyzer -Path $($f.FullName) -Severity Error
    }
}

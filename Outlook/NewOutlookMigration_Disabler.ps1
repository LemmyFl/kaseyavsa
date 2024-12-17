<#
.NOTES
  Version:          1.0.2
  Author:           LemmyFL
  Last Change Date: 17.12.2024
  Purpose:          Creates a one-time scheduled task to set registry keys at first user logon.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$TaskName   = "DisableNewOutlookMigration_RunOnce"
$ScriptPath = "C:\kworking\SetOutlookRegistryKeys.ps1"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Save-RegistryScript {
    $ActionScript = @"
`$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Office\16.0\Outlook\Preferences"
`$RegistryValues = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}
New-Item -Path `$RegPath -Force | Out-Null
`$RegistryValues.GetEnumerator() | ForEach-Object {
    New-ItemProperty -Path `$RegPath -Name `$_.Key -PropertyType DWord -Value `$_.Value -Force | Out-Null
}
"@
    New-Item -ItemType Directory -Path (Split-Path -Path $ScriptPath -Parent) -Force -ErrorAction SilentlyContinue | Out-Null
    Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8 -Force
}

function Register-RunOnceTask {
    Start-Process -FilePath "schtasks.exe" -ArgumentList @(
        "/create", "/tn `"$TaskName`"", 
        "/tr `"powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`"`"", 
        "/sc onlogon", "/rl HIGHEST", "/f", "/z", "/it"
    ) -NoNewWindow -Wait
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Save-RegistryScript
Register-RunOnceTask

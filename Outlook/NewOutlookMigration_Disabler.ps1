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

function Save-DisableOutlookMigrationScript {
    $ActionScript = @"
`$RegSubPath = "Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"
`$RegistryValues = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

`$UserSIDs = Get-WmiObject -Class Win32_UserProfile | Where-Object { 
    `$\_.Loaded -eq `$true -and `$\_.Special -eq `$false 
} | Select-Object -ExpandProperty SID

foreach (`$SID in `$UserSIDs) {
    `$RegPath = "Registry::HKEY_USERS\`$SID\`$RegSubPath"

    New-Item -Path `$RegPath -Force | Out-Null

    foreach (`$Key in `$RegistryValues.Keys) {
        Set-ItemProperty -Path `$RegPath -Name `$Key -Value `$RegistryValues[`$Key] -Type DWord -Force
    }
}
"@

    # Ensure the directory exists
    New-Item -ItemType Directory -Path (Split-Path -Path $ScriptPath -Parent) -Force -ErrorAction SilentlyContinue | Out-Null

    # Save the script content to the specified path
    Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8 -Force
}

function Register-RunOnceTask {
    param (
        [string]$TaskName = "RunOnceTask",
        [string]$ScriptPath
    )

    if (-not (Test-Path $ScriptPath)) { return }

    Start-Process -FilePath "schtasks.exe" -ArgumentList @(
        "/create", "/tn", "`"$TaskName`"",
        "/tr", "`"powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`"`"",
        "/sc", "ONLOGON",
        "/rl", "HIGHEST",
        "/f",
        "/z"
    ) -NoNewWindow -Wait
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Save-RegistryScript
Register-RunOnceTask

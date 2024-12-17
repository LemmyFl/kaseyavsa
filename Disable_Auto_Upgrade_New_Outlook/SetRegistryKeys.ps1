<#
.NOTES
  Version:          1.0.0
  Author:           LemmyFL
  Last Change Date: 17.12.2024
  Purpose:          Sets registry keys to disable Outlook migration for all currently logged-in users. 
                    It targets all loaded user profiles and ensures the registry settings are applied.
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$RegistrySubPath = "Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"
$RegistryValues = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

$CurrentUserSID = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value

$RegPath = "Registry::HKEY_USERS\$CurrentUserSID\$RegistrySubPath"

New-Item -Path $RegPath -Force -ErrorAction SilentlyContinue | Out-Null

foreach ($Key in $RegistryValues.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $RegistryValues[$Key] -Type DWord -Force
}

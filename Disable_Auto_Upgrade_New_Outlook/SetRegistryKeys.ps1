<#
.NOTES
  Version:          1.4.0
  Author:           LemmyFL
  Last Change Date: 18.12.2024
  Purpose:          Disables Outlook migration for all currently loaded user profiles
                    by setting the appropriate registry keys.
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$RegistrySubPath = "Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"
$RegistryValues = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

foreach ($UserSid in (Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -match 'S-1-5-21-\d+-\d+-\d+-\d+$' })) {
    $RegPath = "Registry::HKEY_USERS\$($UserSid.PSChildName)\$RegistrySubPath"
    New-Item -Path $RegPath -Force | Out-Null
    foreach ($Key in $RegistryValues.Keys) {
        New-ItemProperty -Path $RegPath -Name $Key -Value $RegistryValues[$Key] -PropertyType DWord -Force | Out-Null
    }
}

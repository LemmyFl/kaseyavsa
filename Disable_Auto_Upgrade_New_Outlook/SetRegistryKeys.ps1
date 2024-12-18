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

foreach ($UserSid in (Get-ChildItem HKU: | Where-Object { $_.Name -match 'S-1-5-21-\d+-\d+-\d+-\d+$' })) {
    $RegPath = "Registry::$($UserSid.PSChildName)\$RegistrySubPath"
    New-Item -Path $RegPath -Force | Out-Null
    foreach ($Key in $RegistryValues.Keys) {
        Set-ItemProperty -Path $RegPath -Name $Key -Value $RegistryValues[$Key] -Type DWord -Force
    }
}

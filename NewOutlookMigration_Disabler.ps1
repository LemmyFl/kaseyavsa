$users = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -match 'S-\d-\d+(-\d+)+$' }
foreach ($user in $users) {
    $path = "Registry::" + $user.Name + "\Software\Policies\Microsoft\office\16.0\outlook\preferences"
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    Set-ItemProperty -Path $path -Name "NewOutlookMigrationUserSetting" -Value 0 -Type DWord
    Set-ItemProperty -Path $path -Name "NewOutlookAutoMigrationRetryIntervals" -Value 0 -Type DWord
    Set-ItemProperty -Path $path -Name "DoNewOutlookAutoMigration" -Value 0 -Type DWord
    Set-ItemProperty -Path $path -Name "DisableOutlookPSTCreation" -Value 1 -Type DWord  # Neue Zeile 1
    Set-ItemProperty -Path $path -Name "DisableCrossAccountAutoDiscover" -Value 1 -Type DWord  # Neue Zeile 2
}

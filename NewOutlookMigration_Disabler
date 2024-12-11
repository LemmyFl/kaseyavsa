$users = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -match 'S-\d-\d+(-\d+)+$' }
foreach ($user in $users) {
    $path = "Registry::" + $user.Name + "\Software\Policies\Microsoft\office\16.0\outlook\preferences"
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    # Setze den Registry-Wert
    Set-ItemProperty -Path $path -Name "NewOutlookMigrationUserSetting" -Value 0 -Type DWord
}

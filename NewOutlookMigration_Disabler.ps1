$users = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -match 'S-\d-\d+(-\d+)+$' }

$officeVersions = @("14.0", "16.0")

foreach ($user in $users) {
    foreach ($version in $officeVersions) {
        $path = "Registry::" + $user.Name + "\Software\Policies\Microsoft\office\$version\outlook\preferences"

        if (-not (Test-Path -Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }
        Set-ItemProperty -Path $path -Name "NewOutlookMigrationUserSetting" -Value 0 -Type DWord
        Set-ItemProperty -Path $path -Name "NewOutlookAutoMigrationRetryIntervals" -Value 0 -Type DWord
        Set-ItemProperty -Path $path -Name "DoNewOutlookAutoMigration" -Value 0 -Type DWord
    }
}

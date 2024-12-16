$users = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -match 'S-\d-\d+(-\d+)+$' }

foreach ($user in $users) {
    $officeBasePath = "Registry::" + $user.Name + "\Software\Policies\Microsoft\Office"
    if (Test-Path -Path $officeBasePath) {
        $officeVersions = Get-ChildItem -Path $officeBasePath | Where-Object { $_.Name -match '\d+\.\d+' }

        foreach ($version in $officeVersions) {
            $path = $version.PSPath + "\outlook\preferences"
            
            if (-not (Test-Path -Path $path)) {
                New-Item -Path $path -Force
            }
            Set-ItemProperty -Path $path -Name "NewOutlookMigrationUserSetting" -Value 0 -Type DWord
            Set-ItemProperty -Path $path -Name "NewOutlookAutoMigrationRetryIntervals" -Value 0 -Type DWord
            Set-ItemProperty -Path $path -Name "DoNewOutlookAutoMigration" -Value 0 -Type DWord
        }
    }
}

$TaskName = "DisableNewOutlookMigration"

$ActionScript = @"
# Aktion: Registry-Einträge in HKCU setzen, um die Outlook-Migration zu deaktivieren
$RegPath = 'HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences'
$Keys = @{
    'NewOutlookMigrationUserSetting' = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration' = 0
}

# Registry-Schlüssel erstellen/ändern
New-Item -Path $RegPath -Force | Out-Null
foreach ($Key in $Keys.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key]
}
Write-Host '[INFO] Registry-Werte für Outlook-Migration erfolgreich gesetzt.'
"@

$ScriptPath = "C:\Windows\Temp\DisableNewOutlookMigration.ps1"

Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8

schtasks.exe /create `
    /tn $TaskName `
    /tr "powershell.exe -ExecutionPolicy Bypass -File $ScriptPath" `
    /sc onlogon `
    /ru "%username%" `
    /rl HIGHEST `
    /f | Out-Null

Write-Host "[INFO] Task '$TaskName' wurde erstellt. Skript wird bei jedem Benutzer-Login ausgeführt."

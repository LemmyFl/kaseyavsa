$TaskName = "DisableNewOutlookMigration"

$ActionScript = @"
# Aktion: Registry-Einträge in HKCU setzen, um die Outlook-Migration zu deaktivieren
$RegPath = 'HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences'
$Keys = @{
    'NewOutlookMigrationUserSetting' = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration' = 0
}
New-Item -Path $RegPath -Force | Out-Null
foreach ($Key in $Keys.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key]
}
Write-Host '[INFO] Registry-Werte für Outlook-Migration erfolgreich gesetzt.'
"@

$ScriptPath = "C:\kworking\DisableNewOutlookMigration.ps1"

if (-not (Test-Path "C:\kworking")) {
    New-Item -ItemType Directory -Path "C:\kworking" | Out-Null
    Write-Host "[INFO] Ordner 'C:\kworking' wurde erstellt."
}

Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8

schtasks.exe /create `
    /tn $TaskName `
    /tr "powershell.exe -ExecutionPolicy Bypass -File $ScriptPath" `
    /sc onlogon `
    /ru "%username%" `
    /rl HIGHEST `
    /f | Out-Null

Write-Host "[INFO] Task '$TaskName' wurde erstellt. Skript wird bei jedem Benutzer-Login ausgeführt."
Write-Host "[INFO] Ausführbares Skript wurde unter '$ScriptPath' gespeichert."

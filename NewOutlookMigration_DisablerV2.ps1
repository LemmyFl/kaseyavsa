# Name des Tasks
$TaskName = "DisableNewOutlookMigration"

# Aktion: Registry-Werte setzen, um die neue Outlook-Migration zu deaktivieren
$ActionScript = @"
# PowerShell-Aktion für Scheduled Task
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

# Speicherort für das Inline-Skript
$ScriptPath = "C:\kworking\DisableNewOutlookMigration.ps1"

# 1) Ordner erstellen, falls nicht vorhanden
if (-not (Test-Path "C:\kworking")) {
    New-Item -ItemType Directory -Path "C:\kworking" | Out-Null
    Write-Host "[INFO] Ordner 'C:\kworking' wurde erstellt."
}

# 2) Inline-Skript speichern
Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8
Write-Host "[INFO] Ausführbares Skript unter '$ScriptPath' erstellt."

# 3) Scheduled Task erstellen
Write-Host "[INFO] Erstelle Scheduled Task '$TaskName'..."
schtasks.exe /create `
    /tn $TaskName `
    /tr "powershell.exe -ExecutionPolicy Bypass -File $ScriptPath" `
    /sc onlogon `
    /ru "%username%" `
    /rl HIGHEST `
    /f | Out-Null

Write-Host "[SUCCESS] Task '$TaskName' wurde erstellt. Das Skript wird bei jedem Benutzer-Login ausgeführt."

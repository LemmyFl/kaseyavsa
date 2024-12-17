<#
.NOTES
  Version:        00.50.00
  Author:         <LemmyFL>
  Last Change Date:  17.12.2024
#>
# Start-Process -FilePath powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & { $(iwr 'https://raw.githubusercontent.com/LemmyFl/WindowsScripts/main/WindowsRepairScript.ps1' -UseBasicParsing).Content }" -Verb RunAs

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$TaskName = "DisableNewOutlookMigration"
$ScriptPath = "C:\kworking\DisableNewOutlookMigration.ps1"
$RegPath = 'HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences'
$Keys = @{
    'NewOutlookMigrationUserSetting'          = 0
    'NewOutlookAutoMigrationRetryIntervals'   = 0
    'DoNewOutlookAutoMigration'               = 0
}

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Set-RegistryKeys {
    # Stelle sicher, dass der Registry-Pfad existiert
    if (-not (Test-Path -Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Setze die Registry-Werte
    foreach ($Key in $Keys.Keys) {
        Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key] -Force
    }
}

function Save-RegistryScript {
    $ActionScript = @"
`$RegPath = 'HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences'
`$Keys = @{
    'NewOutlookMigrationUserSetting' = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration' = 0
}
if (-not (Test-Path `$RegPath)) {
    New-Item -Path `$RegPath -Force | Out-Null
}
foreach (`$Key in `$Keys.Keys) {
    Set-ItemProperty -Path `$RegPath -Name `$Key -Value `$Keys[`$Key] -Force
}
"@

    Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8 -Force
}

# Funktion: Geplante Aufgabe erstellen
function Register-ScheduledTask {
    Start-Process -FilePath "schtasks.exe" -ArgumentList @(
        "/create",
        "/tn `"$TaskName`"",
        "/tr `"powershell.exe -ExecutionPolicy Bypass -File $ScriptPath`"",
        "/sc onlogon",
        "/rl HIGHEST",
        "/f"
    ) -NoNewWindow -Wait
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

    # Schritt 2: Registry Keys direkt setzen
    Set-RegistryKeys

    # Schritt 3: Skript für Registry Keys speichern
    Save-RegistryScript

    # Schritt 4: Geplante Aufgabe registrieren
    Register-ScheduledTask

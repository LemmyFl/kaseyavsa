# Beispiel: Erstellt oder entfernt einen Task, der bei Login Registry-Werte in HKCU setzt.
param([switch]$Remove)

$TaskName   = "MyLogonTask"
$RegPath    = "HKCU:\Software\MyCompany"
$RegValue   = "TestValue"
$RegData    = 1

if ($Remove) {
    schtasks /delete /tn $TaskName /f | Out-Null
    Write-Host "[INFO] Task entfernt."
    return
}

# 1) Aktion definieren: PowerShell-Befehl, der bei jedem Logon Registry schreibt
$ActionCmd = "powershell.exe -command `"New-Item -Path '$RegPath' -Force; Set-ItemProperty -Path '$RegPath' -Name '$RegValue' -Value $RegData`""

# 2) Scheduled Task anlegen (onlogon, any user)
schtasks /create /tn $TaskName /tr $ActionCmd /sc onlogon /ru "%username%" /rl HIGHEST /f | Out-Null
Write-Host "[INFO] Task angelegt: $TaskName"

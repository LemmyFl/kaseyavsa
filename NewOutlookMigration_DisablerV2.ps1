$TaskName = "DisableNewOutlookMigration"
$ActionScript = @"
$RegPath = 'HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences'
$Keys = @{
    'NewOutlookMigrationUserSetting' = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration' = 0
}
New-Item -Path $RegPath -Force
foreach ($Key in $Keys.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key]
}
"@
$ScriptPath = "C:\kworking\DisableNewOutlookMigration.ps1"

if (-not (Test-Path "C:\kworking")) {
    New-Item -ItemType Directory -Path "C:\kworking"
}
Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8

schtasks.exe /create `
    /tn $TaskName `
    /tr "powershell.exe -ExecutionPolicy Bypass -File $ScriptPath" `
    /sc onlogon `
    /ru "%username%" `
    /rl HIGHEST `
    /f

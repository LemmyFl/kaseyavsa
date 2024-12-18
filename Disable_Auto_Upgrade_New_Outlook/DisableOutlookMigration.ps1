<#
.NOTES
  Version:          1.5.0
  Author:           <LemmyFL>
  Last Change Date: 18.12.2024
  Purpose:          Downloads and executes the SetRegistryKeys.ps1 script, then creates a scheduled task to run it at user logon.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$ScriptDirectory = "C:\kworking"
$DownloadedScript = Join-Path -Path $ScriptDirectory -ChildPath "SetRegistryKeys.ps1"
$TaskName = "DisableOutlookMigration"

#-----------------------------------------------------------[Functions]-----------------------------------------------------------

function Download-SetRegistryKeys {

    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/LemmyFl/kaseyavsa/refs/heads/main/Disable_Auto_Upgrade_New_Outlook/SetRegistryKeys.ps1" -OutFile $DownloadedScript
}

function create-LogonTask {
    schtasks /create `
        /sc ONLOGON `
        /tn "DisableOutlookMigration" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File C:\kworking\SetRegistryKeys.ps1" `
        /ru "SYSTEM" `
        /rl HIGHEST `
        /f
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

Download-SetRegistryKeys

create-LogonTask

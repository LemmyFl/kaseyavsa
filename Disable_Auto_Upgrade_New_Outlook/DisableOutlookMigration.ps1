<#
.NOTES
  Version:          1.3.0
  Author:           <LemmyFL>
  Last Change Date: 17.12.2024
  Purpose:          Download and execute SetRegistryKeys.ps1 script, and create a scheduled task for user logon.
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
        /tn "$TaskName" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File `"$DownloadedScript`"" `
        /sc ONLOGON `
        /rl LIMITED `
        /f
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

Download-SetRegistryKeys

create-LogonTask

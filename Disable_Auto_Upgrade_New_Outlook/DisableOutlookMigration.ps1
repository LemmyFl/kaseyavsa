<#
.NOTES
  Version:          1.3.0
  Author:           <LemmyFL>
  Last Change Date: 17.12.2024
  Purpose:          Download and execute SetRegistryKeys.ps1 script, and create a scheduled task for user logon.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$ScriptDirectory = "C:\ProgramData\Scripts"
$DownloadedScript = Join-Path -Path $ScriptDirectory -ChildPath "SetRegistryKeys.ps1"
$TaskName = "DisableOutlookMigration"

#-----------------------------------------------------------[Functions]-----------------------------------------------------------

function Download-SetRegistryKeys {

    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/LemmyFl/kaseyavsa/refs/heads/main/Disable_Auto_Upgrade_New_Outlook/SetRegistryKeys.ps1" -OutFile $DownloadedScript
}

function create-LogonTask {
    schtasks /create `
        /tn "DisableOutlookMigration" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File `\"C:\ProgramData\Scripts\SetRegistryKeys.ps1`\"" `
        /sc ONLOGON `
        /ru "$env:USERDOMAIN\$env:USERNAME" `
        /it `
        /rl LIMITED `
        /f
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------
mkdir C:\ProgramData\Scripts

Download-SetRegistryKeys

create-LogonTask

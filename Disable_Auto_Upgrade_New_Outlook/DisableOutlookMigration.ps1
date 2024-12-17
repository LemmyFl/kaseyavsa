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
    # Ensure the target directory exists
    if (-not (Test-Path -Path $ScriptDirectory)) {
        New-Item -Path $ScriptDirectory -ItemType Directory -Force | Out-Null
    }

    # Download the SetRegistryKeys.ps1 script
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/LemmyFl/kaseyavsa/refs/heads/main/Disable_Auto_Upgrade_New_Outlook/SetRegistryKeys.ps1" -OutFile $DownloadedScript
}

function Register-LogonTask {
    # Register a scheduled task to run for all users at logon
    schtasks /create `
        /tn "$TaskName" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File `"$DownloadedScript`"" `
        /sc ONLOGON `
        /rl HIGHEST `
        /f
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

Download-SetRegistryKeys

Register-LogonTask

<#
.NOTES
  Version:          1.5.0
  Author:           <LemmyFL>
  Last Change Date: 18.12.2024
  Purpose:          Downloads and executes the SetRegistryKeys.ps1 script, then creates a scheduled task to run it at user logon.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$ScriptDirectory = "C:\scripts"
$TaskName = "DisableOutlookMigration"

#-----------------------------------------------------------[Functions]-----------------------------------------------------------

function create-LogonTask {
    schtasks /create `
        /sc ONLOGON `
        /tn "DisableOutlookMigration" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File C:\scripts\SetRegistryKeys.ps1" `
        /ru "SYSTEM" `
        /rl HIGHEST `
        /f
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

create-LogonTask

& "C:\scripts\SetRegistryKeys.ps1"

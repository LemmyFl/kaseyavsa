<#
.NOTES
  Version:          1.2.0
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
    # Get all user profiles from C:\Users (local users)
    $UserProfiles = Get-ChildItem -Path "C:\Users" -Directory | Select-Object -ExpandProperty Name

    foreach ($UserProfile in $UserProfiles) {
        # Register a scheduled task for each user profile
        schtasks /create `
            /tn "$TaskName-$UserProfile" `
            /tr "powershell.exe -ExecutionPolicy Bypass -File `"$DownloadedScript`"" `
            /sc ONLOGON `
            /ru "$UserProfile" `
            /rl HIGHEST `
            /f
    }
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

# Step 1: Download the external SetRegistryKeys.ps1 script
Download-SetRegistryKeys

# Step 2: Register the logon task
Register-LogonTask

# Step 3: Execute the downloaded script immediately
Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$DownloadedScript`"" -Wait

<#
.NOTES
  Version:          1.1.0
  Author:           LemmyFL (Optimized by ChatGPT)
  Last Change Date: 17.12.2024
  Purpose:          Disable Outlook migration settings and create a one-time task for user logon.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

# Script and Task Settings
$ScriptPath = "C:\kworking\NewOutlookDisable.ps1"
$TaskName   = "DisableOutlookMigration"

# Registry Configuration
$RegistrySubPath = "Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"
$RegistryValues = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

#-----------------------------------------------------------[Functions]-----------------------------------------------------------

function Save-DisableOutlookMigrationScript {
    # Generate script content dynamically
    $ScriptContent = @"
`$RegistrySubPath = "$RegistrySubPath"
`$RegistryValues = @{ $( $RegistryValues.GetEnumerator() | ForEach-Object { "'$($_.Key)' = $($_.Value)" } -join "; " ) }

`$UserProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { `$_.Loaded -and -not `$_.Special }
foreach (`$Profile in `$UserProfiles) {
    `$RegPath = "Registry::HKEY_USERS\`$(`$Profile.SID)\`$RegistrySubPath"
    New-Item -Path `$RegPath -Force -ErrorAction SilentlyContinue | Out-Null
    `$RegistryValues.GetEnumerator() | ForEach-Object {
        Set-ItemProperty -Path `$RegPath -Name `$_.Key -Value `$_.Value -Type DWord -Force
    }
}
"@
    # Save the script to the specified path
    Set-Content -Path $ScriptPath -Value $ScriptContent -Encoding UTF8 -Force
}

function Register-LogonTask {
    # Register a one-time scheduled task for user logon
    schtasks /create `
        /tn "$TaskName" `
        /tr "powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`"" `
        /sc ONLOGON `
        /rl HIGHEST `
        /f /z
}

#-----------------------------------------------------------[Execution]-----------------------------------------------------------

# Step 1: Create the script
Save-DisableOutlookMigrationScript

# Step 2: Register the logon task
Register-LogonTask

# Step 3: Execute the script immediately
& powershell.exe -ExecutionPolicy Bypass -File $ScriptPath

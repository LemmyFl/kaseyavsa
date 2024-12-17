<#
.NOTES
  Version:          00.60.00
  Author:           <LemmyFL>
  Last Change Date: 17.12.2024
  Purpose:          Sets specific Outlook-related registry keys for all users
                    and ensures they remain applied by scheduling a recurring task.
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

# Scheduled Task Name
$TaskName   = "DisableNewOutlookMigration"

# Path to store the PowerShell script
$ScriptPath = "C:\kworking\DisableNewOutlookMigration.ps1"

# Registry keys and values to be set
$Keys       = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Set-RegistryKeysForAllUsers {
    <#
    .SYNOPSIS
        Sets specific registry keys under HKEY_USERS for all user profiles.

    .DESCRIPTION
        Loops through all user profiles in the HKEY_USERS hive and sets the specified
        Outlook registry keys. System profiles such as Local System, Local Service,
        and Network Service are excluded.
    #>

    # Path to HKEY_USERS registry hive
    $HkuPath = "Registry::HKEY_USERS"

    # SIDs of system accounts to exclude
    $ExcludedSIDs = @("S-1-5-18", "S-1-5-19", "S-1-5-20")

    # Loop through all user profiles in HKEY_USERS
    Get-ChildItem -Path $HkuPath | Where-Object {
        $_.PSChildName -notin $ExcludedSIDs -and $_.PSChildName -match '^S-1-5-21'
    } | ForEach-Object {
        # Retrieve the user SID
        $UserSid = $_.PSChildName

        # Define the registry path for the user
        $RegPath = "Registry::HKEY_USERS\$UserSid\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"

        # Ensure the registry path exists; create it if it does not
        if (-not (Test-Path -Path $RegPath)) {
            New-Item -Path $RegPath -Force | Out-Null
        }

        # Set the registry values for each key
        foreach ($Key in $Keys.Keys) {
            Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key] -Force
        }
    }
}

function Save-RegistryScript {
    <#
    .SYNOPSIS
        Saves a PowerShell script that sets the required registry keys for all users.

    .DESCRIPTION
        This script is stored locally and is scheduled to run at user logon to ensure
        the required registry keys are always applied.
    #>

    # Script content to set registry keys for all users
    $ActionScript = @"
`$Keys = @{
    'NewOutlookMigrationUserSetting'        = 0
    'NewOutlookAutoMigrationRetryIntervals' = 0
    'DoNewOutlookAutoMigration'             = 0
}

`$HkuPath = "Registry::HKEY_USERS"
`$ExcludedSIDs = @("S-1-5-18", "S-1-5-19", "S-1-5-20")

Get-ChildItem -Path `$HkuPath | Where-Object {
    `$_.PSChildName -notin `$ExcludedSIDs -and `$_.PSChildName -match '^S-1-5-21'
} | ForEach-Object {
    `$UserSid = `$_.PSChildName
    `$RegPath = "Registry::HKEY_USERS`\$UserSid\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences"

    if (-not (Test-Path -Path `$RegPath)) {
        New-Item -Path `$RegPath -Force | Out-Null
    }
    foreach (`$Key in `$Keys.Keys) {
        Set-ItemProperty -Path `$RegPath -Name `$Key -Value `$Keys[`$Key] -Force
    }
}
"@

    # Ensure the parent directory exists
    if (-not (Test-Path (Split-Path -Path $ScriptPath -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path -Path $ScriptPath -Parent) -Force | Out-Null
    }

    # Save the script content to the specified path
    Set-Content -Path $ScriptPath -Value $ActionScript -Encoding UTF8 -Force
}

function Register-ScheduledTask {
    <#
    .SYNOPSIS
        Creates a scheduled task to run the saved script at user logon.

    .DESCRIPTION
        The task runs with elevated privileges to ensure the registry keys are applied
        for all user profiles whenever a user logs in.
    #>

    # Use schtasks to create a task that runs the script on user logon
    Start-Process -FilePath "schtasks.exe" -ArgumentList @(
        "/create",                             # Create a new task
        "/tn `"$TaskName`"",                   # Task name
        "/tr `"powershell.exe -ExecutionPolicy Bypass -File $ScriptPath`"", # Task action
        "/sc onlogon",                         # Trigger: At user logon
        "/rl HIGHEST",                         # Run with highest privileges
        "/f"                                   # Force task creation
    ) -NoNewWindow -Wait
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Step 1: Set registry keys for all user profiles
Set-RegistryKeysForAllUsers

# Step 2: Save a script that sets the registry keys (to ensure persistence)
Save-RegistryScript

# Step 3: Create a scheduled task to run the script at user logon
Register-ScheduledTask

<#
.NOTES
  Version:        01.02.00
  Author:         <LemmyFL>
  Last Change Date:  17.12.2024
#>
# Start-Process -FilePath powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & { $(iwr 'https://raw.githubusercontent.com/LemmyFl/WindowsScripts/main/WindowsRepairScript.ps1' -UseBasicParsing).Content }" -Verb RunAs
#-----------------------------------------------------------[Functions]------------------------------------------------------------


#-----------------------------------------------------------[Execution]------------------------------------------------------------

@echo off
REM --------------------------------------------------
REM Name:     SetOutlook16Preferences.bat
REM Zweck:    Setzt bestimmte Outlook-Registry-Keys in HKCU
REM Version:  1.0
REM --------------------------------------------------

echo [INFO] Setze Outlook-Registry Keys in HKCU...

REM 1) Basis-Schlüssel anlegen (Software\Policies\Microsoft\Office\16.0\Outlook\Preferences)
REM    /f = force overwrite
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences" /f

REM 2) Einzelne Werte setzen (DWORD-Werte)
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences" ^
    /v NewOutlookMigrationUserSetting /t REG_DWORD /d 0 /f

REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences" ^
    /v NewOutlookAutoMigrationRetryIntervals /t REG_DWORD /d 0 /f

REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Outlook\Preferences" ^
    /v DoNewOutlookAutoMigration /t REG_DWORD /d 0 /f

echo [INFO] Fertig! Registry Keys wurden erfolgreich gesetzt.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Funktion zur Anzeige der Nachricht
function Show-FullScreenMessage {
    param (
        [string]$Message = "Die Windows 11 Installation dauert bis zu 2 Stunden." + [Environment]::NewLine +
                           "Bitte schalten Sie den PC nicht aus!" + [Environment]::NewLine + [Environment]::NewLine +
                           "Der PC startet automatisch neu.",
        [string]$BackgroundColor = "Blue",
        [string]$TextColor = "White"
    )

    # Erstelle Vollbildfenster auf jedem Monitor
    [System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
        $form = New-Object System.Windows.Forms.Form
        $form.WindowState = 'Maximized'
        $form.FormBorderStyle = 'None'
        $form.BackColor = $BackgroundColor
        $form.Bounds = $_.Bounds
        $form.TopMost = $true

        # Füge die Nachricht hinzu
        $label = New-Object System.Windows.Forms.Label
        $label.Text = $Message
        $label.Font = New-Object System.Drawing.Font('Arial', 32, [System.Drawing.FontStyle]::Bold)
        $label.ForeColor = $TextColor
        $label.TextAlign = 'MiddleCenter'
        $label.Dock = 'Fill'

        $form.Controls.Add($label)
        $form.Add_Shown({ 
            $form.Activate()
            Start-Sleep -Seconds 10 # Nachricht 10 Sekunden anzeigen
            $form.Close() # Fenster automatisch schließen
        })
        $form.ShowDialog() # Fenster als modales Fenster öffnen
    }
}

# Nachricht anzeigen und Skript beenden
Show-FullScreenMessage

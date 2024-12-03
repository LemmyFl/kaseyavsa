# Neues PowerShell-Fenster für die Vollbildanzeige starten
Start-Process powershell -ArgumentList "-NoProfile -WindowStyle Hidden -Command {
    Add-Type -AssemblyName System.Windows.Forms;
    Add-Type -AssemblyName System.Drawing;

    # Erstelle Vollbildfenster auf allen Monitoren
    [System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
        $form = New-Object System.Windows.Forms.Form
        $form.WindowState = 'Maximized'
        $form.FormBorderStyle = 'None'
        $form.BackColor = 'Blue'
        $form.Bounds = $_.Bounds
        $form.TopMost = $true

        # Nachricht mit Zeilenumbrüchen
        $label = New-Object System.Windows.Forms.Label
        $label.Text = 'Die Windows 11 Installation dauert bis zu 2 Stunden.' + [Environment]::NewLine +
                      'Bitte schalten Sie den PC nicht aus!' + [Environment]::NewLine + [Environment]::NewLine +
                      'Der PC startet automatisch neu!'
        $label.Font = New-Object System.Drawing.Font('Arial', 32, [System.Drawing.FontStyle]::Bold)
        $label.ForeColor = 'White'
        $label.BackColor = 'Blue'
        $label.TextAlign = 'MiddleCenter'
        $label.Dock = 'Fill'

        # Nachricht zum Fenster hinzufügen
        $form.Controls.Add($label)
        $form.Add_Shown({ $form.Activate() })

        # Fenster dauerhaft offen lassen
        $form.ShowDialog()
    }

    # Halte die Anwendung aktiv
    [System.Windows.Forms.Application]::Run()
}"

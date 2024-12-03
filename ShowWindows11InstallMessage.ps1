Start-Process powershell -ArgumentList "-NoProfile -WindowStyle Hidden -Command {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Fenster erstellen
    $form = New-Object System.Windows.Forms.Form
    $form.WindowState = 'Maximized'
    $form.FormBorderStyle = 'None'
    $form.BackColor = 'Blue'
    $form.TopMost = $true

    # Nachricht mit Zeilenumbrüchen
    $label = New-Object System.Windows.Forms.Label
    $label.Text = 'Die Windows 11 Installation dauert bis zu 2 Stunden.' + [Environment]::NewLine +
                  'Bitte schalten Sie den PC nicht aus!' + [Environment]::NewLine + [Environment]::NewLine +
                  'Der PC startet automatisch neu!'
    $label.Font = New-Object System.Drawing.Font('Arial', 32, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = 'White'
    $label.Dock = 'Fill'
    $label.TextAlign = 'MiddleCenter'

    # Nachricht hinzufügen und Fenster anzeigen
    $form.Controls.Add($label)
    $form.ShowDialog()
}" -NoNewWindow -PassThru | Out-Null

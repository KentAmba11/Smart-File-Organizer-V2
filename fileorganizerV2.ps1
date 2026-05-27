Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Capture the exact folder where the app is running
$script:basePath = $PSScriptRoot
if (-not $script:basePath) { 
    $script:basePath = [System.AppDomain]::CurrentDomain.BaseDirectory 
}

# ==========================================
# 1. MAIN WINDOW SETUP
# ==========================================
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Smart File Organizer V2"
$mainForm.Size = New-Object System.Drawing.Size(480, 365)
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "FixedSingle"
$mainForm.MaximizeBox = $false
$mainForm.BackColor = [System.Drawing.Color]::FromArgb(244, 244, 246)

$iconPath = Join-Path $script:basePath "applogo.ico"
if (Test-Path $iconPath) {
    $mainForm.Icon = New-Object System.Drawing.Icon($iconPath)
}

# ==========================================
# 2. HEADER TYPOGRAPHY SECTION
# ==========================================
$lblHeaderTitle = New-Object System.Windows.Forms.Label
$lblHeaderTitle.Text = "File Organizer"
$lblHeaderTitle.Location = New-Object System.Drawing.Point(22, 16)
$lblHeaderTitle.Size = New-Object System.Drawing.Size(250, 28)
$lblHeaderTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblHeaderTitle.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 35)

$lblHeaderSub = New-Object System.Windows.Forms.Label
$lblHeaderSub.Text = "Clean and categorize your directories instantly."
$lblHeaderSub.Location = New-Object System.Drawing.Point(24, 44)
$lblHeaderSub.Size = New-Object System.Drawing.Size(280, 18)
$lblHeaderSub.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$lblHeaderSub.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 145)

# Minimalist Support Button
$btnSupport = New-Object System.Windows.Forms.Button
$btnSupport.Text = "Support"
$btnSupport.Location = New-Object System.Drawing.Point(345, 18)
$btnSupport.Size = New-Object System.Drawing.Size(95, 32)
$btnSupport.FlatStyle = "Flat"
$btnSupport.FlatAppearance.BorderSize = 0
$btnSupport.BackColor = [System.Drawing.Color]::FromArgb(230, 245, 235)
$btnSupport.ForeColor = [System.Drawing.Color]::FromArgb(40, 140, 70)
$btnSupport.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# ==========================================
# 3. THE "CARD" CONTAINER PANEL
# ==========================================
$cardPanel = New-Object System.Windows.Forms.Panel
$cardPanel.Location = New-Object System.Drawing.Point(22, 85)
$cardPanel.Size = New-Object System.Drawing.Size(420, 115)
$cardPanel.BackColor = [System.Drawing.Color]::White

$lblSelect = New-Object System.Windows.Forms.Label
$lblSelect.Text = "TARGET DIRECTORY"
$lblSelect.Location = New-Object System.Drawing.Point(16, 16)
$lblSelect.Size = New-Object System.Drawing.Size(200, 15)
$lblSelect.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$lblSelect.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 165)

# Flat Input Wrapper
$inputWrapper = New-Object System.Windows.Forms.Panel
$inputWrapper.Location = New-Object System.Drawing.Point(16, 42)
$inputWrapper.Size = New-Object System.Drawing.Size(280, 36)
$inputWrapper.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 248)

$script:txtPath = New-Object System.Windows.Forms.TextBox
$script:txtPath.BorderStyle = "None"
$script:txtPath.Location = New-Object System.Drawing.Point(10, 10)
$script:txtPath.Size = New-Object System.Drawing.Size(260, 18)
$script:txtPath.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 248)
$script:txtPath.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$script:txtPath.ForeColor = [System.Drawing.Color]::FromArgb(50, 50, 55)
$script:txtPath.Text = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), "Downloads")

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse"
$btnBrowse.Location = New-Object System.Drawing.Point(308, 42)
$btnBrowse.Size = New-Object System.Drawing.Size(96, 36)
$btnBrowse.FlatStyle = "Flat"
$btnBrowse.FlatAppearance.BorderSize = 0
$btnBrowse.BackColor = [System.Drawing.Color]::FromArgb(235, 235, 240)
$btnBrowse.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnBrowse.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

$cardPanel.Controls.Add($lblSelect)
$inputWrapper.Controls.Add($script:txtPath)
$cardPanel.Controls.Add($inputWrapper)
$cardPanel.Controls.Add($btnBrowse)

# ==========================================
# 4. PRIMARY ACCENT ACTION BUTTON
# ==========================================
$btnOrganize = New-Object System.Windows.Forms.Button
$btnOrganize.Text = "Organize Directory"
$btnOrganize.Location = New-Object System.Drawing.Point(22, 220)
$btnOrganize.Size = New-Object System.Drawing.Size(420, 52)
$btnOrganize.FlatStyle = "Flat"
$btnOrganize.FlatAppearance.BorderSize = 0
$btnOrganize.BackColor = [System.Drawing.Color]::FromArgb(243, 114, 44)
$btnOrganize.ForeColor = [System.Drawing.Color]::White
$btnOrganize.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)

# Progress Bar
$script:progressBar = New-Object System.Windows.Forms.ProgressBar
$script:progressBar.Location = New-Object System.Drawing.Point(22, 288)
$script:progressBar.Size = New-Object System.Drawing.Size(420, 5)
$script:progressBar.Style = "Marquee"
$script:progressBar.MarqueeAnimationSpeed = 25
$script:progressBar.Visible = $false

# Watermark Label
$lblWatermark = New-Object System.Windows.Forms.Label
$lblWatermark.Text = "Made by Rigel Kent Amba"
$lblWatermark.Location = New-Object System.Drawing.Point(22, 302)
$lblWatermark.Size = New-Object System.Drawing.Size(420, 16)
$lblWatermark.TextAlign = "MiddleRight"
$lblWatermark.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
$lblWatermark.ForeColor = [System.Drawing.Color]::FromArgb(175, 175, 180)

# ==========================================
# 5. FIRST OPEN TUTORIAL INSTRUCTION WINDOW
# ==========================================
function Show-OnboardingGuide {
    $guideForm = New-Object System.Windows.Forms.Form
    $guideForm.Text = "How It Works"
    $guideForm.Size = New-Object System.Drawing.Size(430, 440)
    $guideForm.StartPosition = "CenterParent"
    $guideForm.FormBorderStyle = "FixedDialog"
    $guideForm.MaximizeBox = $false
    $guideForm.BackColor = [System.Drawing.Color]::White

    $lblGuideTitle = New-Object System.Windows.Forms.Label
    $lblGuideTitle.Text = "Welcome to File Organizer!"
    $lblGuideTitle.Location = New-Object System.Drawing.Point(20, 20)
    $lblGuideTitle.Size = New-Object System.Drawing.Size(380, 25)
    $lblGuideTitle.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
    $lblGuideTitle.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 35)

    # NEW: High-performance text control layer for natively smooth pixel-by-pixel scrolling
    $txtInstructions = New-Object System.Windows.Forms.RichTextBox
    $txtInstructions.Location = New-Object System.Drawing.Point(22, 60)
    $txtInstructions.Size = New-Object System.Drawing.Size(382, 250)
    $txtInstructions.ReadOnly = $true
    $txtInstructions.BorderStyle = "None"
    $txtInstructions.BackColor = [System.Drawing.Color]::White
    $txtInstructions.ScrollBars = "Vertical"
    $txtInstructions.ForeColor = [System.Drawing.Color]::FromArgb(75, 75, 80)
    $txtInstructions.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)

    # Updated instructions text targeting Windows 11 expanded context menu scenarios
    $txtInstructions.Text = "Declutter your target folders in easy steps:`n`n" +
                            "1. Choose Your Target`n" +
                            "The system defaults to your Downloads folder, but you can target any directory using the 'Browse' button.`n`n" +
                            "2. Run the Organizer`n" +
                            "Click the coral 'Organize Directory' button to instantly group loose files.`n`n" +
                            "3. Instant Categorization`n" +
                            "Your files automatically move into clean dedicated subfolders.`n`n" +
                            "[*] Quick Access Tip (Pin to Taskbar):`n" +
                            "To open the app instantly without hassle, right-click your compiled 'fileorganizerV2.exe' application file and select 'Pin to taskbar'.`n`n" +
                            "Note: If you do not see 'Pin to taskbar' listed immediately on Windows 11, click 'Show more options' at the bottom of the right-click menu to expand the selection."

    $btnDismissGuide = New-Object System.Windows.Forms.Button
    $btnDismissGuide.Text = "Get Started"
    $btnDismissGuide.Location = New-Object System.Drawing.Point(22, 330)
    $btnDismissGuide.Size = New-Object System.Drawing.Size(370, 45)
    $btnDismissGuide.FlatStyle = "Flat"
    $btnDismissGuide.FlatAppearance.BorderSize = 0
    $btnDismissGuide.BackColor = [System.Drawing.Color]::FromArgb(243, 114, 44)
    $btnDismissGuide.ForeColor = [System.Drawing.Color]::White
    $btnDismissGuide.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnDismissGuide.Add_Click({ $guideForm.Close() })

    # UI Polishing Event: Seamlessly shifts focus to button if user clicks text canvas to hide blinking caret line
    $txtInstructions.Add_GotFocus({ $btnDismissGuide.Focus() })

    $guideForm.Controls.Add($lblGuideTitle)
    $guideForm.Controls.Add($txtInstructions)
    $guideForm.Controls.Add($btnDismissGuide)
    $guideForm.ShowDialog($mainForm) | Out-Null
}

$mainForm.Add_Load({
    $markerFile = Join-Path $script:basePath ".firstrun"
    if (-not (Test-Path $markerFile)) {
        Show-OnboardingGuide
        New-Item -Path $markerFile -ItemType "File" -Force | Out-Null
    }
})

# ==========================================
# 6. INTERACTIVE EVENTS & LOGIC
# ==========================================
$btnBrowse.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Choose the folder you want organized"
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $script:txtPath.Text = $folderBrowser.SelectedPath
    }
})

$btnSupport.Add_Click({
    $supportForm = New-Object System.Windows.Forms.Form
    $supportForm.Text = "Support"
    $supportForm.Size = New-Object System.Drawing.Size(360, 230)
    $supportForm.StartPosition = "CenterParent"
    $supportForm.FormBorderStyle = "FixedDialog"
    $supportForm.MaximizeBox = $false
    $supportForm.BackColor = [System.Drawing.Color]::FromArgb(244, 244, 246)

    $lblPop = New-Object System.Windows.Forms.Label
    $lblPop.Text = "Thank you for supporting Kent!"
    $lblPop.Location = New-Object System.Drawing.Point(10, 24)
    $lblPop.Size = New-Object System.Drawing.Size(320, 25)
    $lblPop.TextAlign = "MiddleCenter"
    $lblPop.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $lblPop.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 35)
    $supportForm.Controls.Add($lblPop)

    $lblGcash = New-Object System.Windows.Forms.Label
    $lblGcash.Text = "GCash: 0998 338 4034"
    $lblGcash.Location = New-Object System.Drawing.Point(20, 70)
    $lblGcash.Size = New-Object System.Drawing.Size(300, 32)
    $lblGcash.TextAlign = "MiddleCenter"
    $lblGcash.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $lblGcash.ForeColor = [System.Drawing.Color]::FromArgb(30, 120, 230)
    $lblGcash.BackColor = [System.Drawing.Color]::White
    $supportForm.Controls.Add($lblGcash)

    $lblBpi = New-Object System.Windows.Forms.Label
    $lblBpi.Text = "BPI: 1359 1656 77"
    $lblBpi.Location = New-Object System.Drawing.Point(20, 116)
    $lblBpi.Size = New-Object System.Drawing.Size(300, 32)
    $lblBpi.TextAlign = "MiddleCenter"
    $lblBpi.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $lblBpi.ForeColor = [System.Drawing.Color]::FromArgb(180, 40, 40)
    $lblBpi.BackColor = [System.Drawing.Color]::White
    $supportForm.Controls.Add($lblBpi)

    $supportForm.ShowDialog($mainForm) | Out-Null
})

$btnOrganize.Add_Click({
    $targetFolder = $script:txtPath.Text

    if ([string]::IsNullOrWhiteSpace($targetFolder)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a folder to clean up first!", "Missing Path", "OK", "Warning") | Out-Null
        return
    }

    if (-not (Test-Path -Path $targetFolder)) {
        [System.Windows.Forms.MessageBox]::Show("The targeted cleanup folder path does not exist.", "Path Missing", "OK", "Error") | Out-Null
        return
    }

    $btnOrganize.Enabled = $false
    $btnOrganize.Text = "Organizing Files..."
    $btnOrganize.BackColor = [System.Drawing.Color]::FromArgb(180, 185, 190)
    $script:progressBar.Visible = $true
    [System.Windows.Forms.Application]::DoEvents()

    $sortingRules = @{
        "Documents"   = @(".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".rtf")
        "Images"      = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".ico")
        "Videos"      = @(".mp4", ".mkv", ".avi", ".mov", ".wmv", ".flv")
        "Music"       = @(".mp3", ".wav", ".wma", ".flac", ".aac")
        "Archives"    = @(".zip", ".rar", ".7z", ".tar", ".gz")
        "Executables" = @(".exe", ".msi", ".bat", ".cmd")
    }

    try {
        $files = Get-ChildItem -Path $targetFolder -File
        if ($files.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No loose files found to sort in this folder.", "Clean Folder", "OK", "Information") | Out-Null
            return
        }

        $movedCounter = 0
        foreach ($file in $files) {
            $ext = $file.Extension.ToLower()
            $assignedFolder = "Others"

            foreach ($category in $sortingRules.Keys) {
                if ($sortingRules[$category] -contains $ext) {
                    $assignedFolder = $category
                    break
                }
            }

            $destinationPath = Join-Path $targetFolder $assignedFolder
            if (-not (Test-Path $destinationPath)) {
                New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
            }

            Move-Item -Path $file.FullName -Destination $destinationPath -Force
            $movedCounter++
            [System.Windows.Forms.Application]::DoEvents() 
        }

        [System.Windows.Forms.MessageBox]::Show("Success! Organized $movedCounter files into clean folders.", "Task Finished", "OK", "Information") | Out-Null
    }
    catch {
        $errMsg = "An unexpected error occurred during processing:`n`n'$_'`n`nPlease report this bug to Rigel Kent Amba so it can be fixed!"
        [System.Windows.Forms.MessageBox]::Show($errMsg, "Bug Detected", "OK", "Error") | Out-Null
    }
    finally {
        $btnOrganize.Enabled = $true
        $btnOrganize.Text = "Organize Directory"
        $btnOrganize.BackColor = [System.Drawing.Color]::FromArgb(243, 114, 44)
        $script:progressBar.Visible = $false
    }
})

# ==========================================
# 7. APP ENGINE ASSEMBLY
# ==========================================
$mainForm.Controls.Add($lblHeaderTitle)
$mainForm.Controls.Add($lblHeaderSub)
$mainForm.Controls.Add($btnSupport)
$mainForm.Controls.Add($cardPanel)
$mainForm.Controls.Add($btnOrganize)
$mainForm.Controls.Add($script:progressBar)
$mainForm.Controls.Add($lblWatermark)

[System.Windows.Forms.Application]::Run($mainForm)
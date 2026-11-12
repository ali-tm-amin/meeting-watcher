# Meeting Watcher for Windows — installer by IhsanOps — https://ihsanops.ai
#
# BETA — not tested on a real Windows machine yet. Please tell us what happens:
# https://github.com/ali-tm-amin/meeting-watcher/issues
#
# Open PowerShell (not as administrator) and paste:
#   irm https://ihsanops.ai/meet.ps1 | iex
# (or, if that link is down: irm https://raw.githubusercontent.com/ali-tm-amin/meeting-watcher/main/windows/install.ps1 | iex)
#
# Safe to run again: it updates an existing install. Never asks for admin.
$ErrorActionPreference = 'Stop'

$Repo   = if ($env:MW_REPO)   { $env:MW_REPO }   else { 'ali-tm-amin/meeting-watcher' }
$Branch = if ($env:MW_BRANCH) { $env:MW_BRANCH } else { 'main' }
$Base   = "https://raw.githubusercontent.com/$Repo/$Branch/windows"

$Dir      = Join-Path $HOME 'meeting-watcher'
$TaskName = 'IhsanOps Meeting Watcher'

function Bold([string]$s) { Write-Host $s -ForegroundColor White }
function Ok([string]$s)   { Write-Host "  [ok] $s" -ForegroundColor Green }
function Warn([string]$s) { Write-Host "  [!]  $s" -ForegroundColor Yellow }
function Fail([string]$s) { Write-Host "  [x]  $s" -ForegroundColor Red; exit 1 }

Write-Host ''
Bold 'Meeting Watcher — by IhsanOps  (Windows BETA)'
Write-Host 'Pops up Meetily the moment a Zoom or Teams call starts.'
Write-Host ''

# ---- 1. Check the PC --------------------------------------------------------
Bold '1/4 Checking your PC'
if (-not $IsWindows -and $env:OS -ne 'Windows_NT') { Fail 'This installer only works on Windows. On a Mac use: curl -fsSL https://ihsanops.ai/meet.sh | bash' }
$build = [Environment]::OSVersion.Version.Build
if ($build -lt 18362) { Fail "Windows 10 version 1903 or newer is needed (you have build $build). Update in Settings → Windows Update." }
if ($PSVersionTable.PSEdition -ne 'Desktop') { Warn 'Run this in "Windows PowerShell" (the blue one), not PowerShell 7. Continuing anyway.' }
Ok "Windows build $build"

# ---- 2. Download the watcher ------------------------------------------------
Bold '2/4 Downloading Meeting Watcher'
New-Item -ItemType Directory -Path $Dir -Force | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

function Get-File([string]$Name) {
    try { Invoke-WebRequest -Uri "$Base/$Name" -OutFile (Join-Path $Dir $Name) -UseBasicParsing }
    catch { Fail "Couldn't download $Name. Check your internet connection and try again." }
}
Get-File 'meeting-watcher.ps1'
Get-File 'uninstall.ps1'
Unblock-File -Path (Join-Path $Dir '*.ps1') -ErrorAction SilentlyContinue
Ok "Installed to $Dir"

# ---- 3. Meetily -------------------------------------------------------------
Bold '3/4 Checking for Meetily'
$meetily = @(
    (Join-Path $env:LOCALAPPDATA 'Programs\meetily\meetily.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Meetily\Meetily.exe'),
    (Join-Path $env:LOCALAPPDATA 'meetily\meetily.exe'),
    (Join-Path $env:ProgramFiles 'meetily\meetily.exe'),
    (Join-Path $env:ProgramFiles 'Meetily\Meetily.exe')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $meetily) {
    $meetily = Get-ChildItem -Path (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs') -Recurse -Filter '*meetily*.lnk' -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
}
if ($meetily) {
    Ok "Meetily found: $meetily"
} else {
    Warn "Meetily isn't installed. Opening the download page — install the Windows version, then you're done."
    Start-Process 'https://github.com/Zackriya-Solutions/meeting-minutes/releases/latest' | Out-Null
}

# Summary template: Meetily reads extra templates from %APPDATA%\Meetily\templates.
# Ours keeps words spoken in another language (Arabic, Urdu, ...) in Latin letters
# with the English meaning in brackets, and adds a glossary. It replaces the default
# "Standard Meeting Notes" template; delete the file to go back to Meetily's own.
$Templates = Join-Path $env:APPDATA 'Meetily\templates'
try {
    New-Item -ItemType Directory -Path $Templates -Force | Out-Null
    $tmp = Join-Path $Templates 'standard_meeting.json.tmp'
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/$Repo/$Branch/meetily/standard_meeting.json" -OutFile $tmp -UseBasicParsing
    $null = Get-Content $tmp -Raw | ConvertFrom-Json
    Move-Item -Path $tmp -Destination (Join-Path $Templates 'standard_meeting.json') -Force
    Ok 'Summary template installed (keeps Arabic and other non-English terms, adds a glossary)'
} catch {
    Remove-Item -Path (Join-Path $Templates 'standard_meeting.json.tmp') -ErrorAction SilentlyContinue
    Warn "Couldn't install the summary template - Meetily will use its own. Not a problem."
}

# ---- 4. Start in the background --------------------------------------------
Bold '4/4 Starting Meeting Watcher'
$script = Join-Path $Dir 'meeting-watcher.ps1'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument "-NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
$trigger   = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
$settings  = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) `
    -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings `
    -Description 'Opens Meetily when a Zoom or Teams call starts. https://ihsanops.ai/meet' | Out-Null
Start-ScheduledTask -TaskName $TaskName
Start-Sleep -Seconds 2
$state = (Get-ScheduledTask -TaskName $TaskName).State
if ($state -eq 'Running') { Ok 'Running now, and starts automatically when you sign in' }
else { Warn "Task registered but its state is '$state'. Open Task Scheduler and run '$TaskName' by hand, then tell us." }

# One-time test notification
try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>Meeting Watcher is on</text><text>You will get a pop-up like this when a Zoom or Teams call starts.</text></binding></visual></toast>")
    $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show((New-Object Windows.UI.Notifications.ToastNotification $xml))
} catch { Warn "Couldn't show a test notification ($($_.Exception.Message)). Check Settings → System → Notifications." }

Write-Host ''
Bold 'All done. Three quick things in Meetily:'
Write-Host '  1. Open Meetily and allow Microphone access if Windows asks.'
Write-Host '  2. Choose the transcription model: Parakeet for English-only calls,'
Write-Host '     Whisper if your calls mix in Arabic or other languages.'
Write-Host '  3. Test it: join https://zoom.us/test — Meetily pops up within ~20 seconds.'
Write-Host ''
Write-Host "  Summaries use the 'Standard Meeting Notes + glossary' template: English only,"
Write-Host '  with Arabic or other non-English terms kept and explained in brackets.'
Write-Host ''
Write-Host "  See what it detected:  Get-Content $Dir\meeting-watcher.log"
Write-Host "  Apps on the mic now:   powershell -ExecutionPolicy Bypass -File $Dir\meeting-watcher.ps1 -Once"
Write-Host "  Uninstall:             powershell -ExecutionPolicy Bypass -File $Dir\uninstall.ps1"
Write-Host ''
Write-Host '  This Windows version is new and not tested yet. If anything fails, please tell us:'
Write-Host '  https://github.com/ali-tm-amin/meeting-watcher/issues'
Write-Host ''
Write-Host '  Did Meetily pop up on your first call? One line to ali@ihsanops.co.uk'
Write-Host '  tells us whether this works beyond our own machines. Yes or no, both help.'
Write-Host ''
Write-Host '  Prefer us to set it up for you? £49 Quick Setup → https://ihsanops.ai/meet'
Write-Host '  Want transcripts filed into your CRM automatically? From £250 → https://ihsanops.ai/meet'
Write-Host ''

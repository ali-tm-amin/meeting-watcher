# Meeting Watcher for Windows by IhsanOps — https://ihsanops.ai
#
# BETA — not tested on a real Windows machine yet. If something breaks, please
# open an issue: https://github.com/ali-tm-amin/meeting-watcher/issues
#
# Detects Zoom / Teams calls by asking Windows which apps are using the
# microphone (the same data behind the mic icon in the system tray), then opens
# Meetily and reminds you to start recording. YouTube, podcasts and dictation
# apps never match, so they are ignored. Nothing is recorded by this script and
# nothing leaves your PC — you stay in control of what gets recorded.
#
# Run with -Once to print the apps using the mic right now and exit:
#   powershell -ExecutionPolicy Bypass -File ~\meeting-watcher\meeting-watcher.ps1 -Once
#
# Needs Windows PowerShell 5.1 (built into Windows 10/11). Not PowerShell 7.
param([switch]$Once)

$Dir = Join-Path $HOME 'meeting-watcher'
$Log = Join-Path $Dir 'meeting-watcher.log'

# Defaults (override any of these in ~\meeting-watcher\config.ps1)
$INTERVAL     = 10       # seconds between checks
$START_AFTER  = 2        # meeting app on mic for 2 checks (~20s) = meeting started
$END_AFTER    = 6        # meeting app off mic for 6 checks (~60s) = meeting ended
$RECORDER_APP = ''       # full path to meetily.exe; blank = find it automatically
# Zoom = Zoom.exe (desktop) or ZoomVideoCommunications.* (Store)
# Teams = MSTeams_* (new Teams) or Teams.exe / ms-teams.exe (classic)
$MEETING_PATTERN = '(?i)(\\Zoom\.exe$|^ZoomVideoCommunications\.|^MSTeams_|\\Teams\.exe$|\\ms-teams\.exe$)'

$ConfigFile = Join-Path $Dir 'config.ps1'
if (Test-Path $ConfigFile) { . $ConfigFile }

function Write-Log([string]$Message) {
    try { Add-Content -Path $Log -Value ("{0} {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message) } catch {}
}

# Which apps are using the microphone right now?
# Windows keeps a per-app record under CapabilityAccessManager\ConsentStore\microphone.
# LastUsedTimeStart > 0 and LastUsedTimeStop = 0 means "using it now".
function Get-MicUsers {
    $root = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone'
    $users = @()
    foreach ($key in (Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue)) {
        $p = Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue
        if ($null -eq $p -or $null -eq $p.LastUsedTimeStart) { continue }
        if ([int64]$p.LastUsedTimeStart -gt 0 -and [int64]$p.LastUsedTimeStop -eq 0) {
            # Non-packaged apps are stored as C:#Users#you#...#Zoom.exe
            $users += ($key.PSChildName -replace '#', '\')
        }
    }
    return $users
}

function Get-MeetingLabel([string]$Id) {
    if ($Id -match '(?i)zoom')  { return 'Zoom' }
    if ($Id -match '(?i)teams') { return 'Teams' }
    return $Id
}

function Find-Meetily {
    if ($RECORDER_APP -and (Test-Path $RECORDER_APP)) { return $RECORDER_APP }
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\meetily\meetily.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Meetily\Meetily.exe'),
        (Join-Path $env:LOCALAPPDATA 'meetily\meetily.exe'),
        (Join-Path $env:ProgramFiles 'meetily\meetily.exe'),
        (Join-Path $env:ProgramFiles 'Meetily\Meetily.exe')
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    # Fall back to a Start Menu shortcut
    $menus = @(
        (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'),
        (Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs')
    )
    foreach ($m in $menus) {
        $lnk = Get-ChildItem -Path $m -Recurse -Filter '*meetily*.lnk' -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($lnk) { return $lnk.FullName }
    }
    return $null
}

function Open-Meetily {
    $app = Find-Meetily
    if ($app) {
        try { Start-Process -FilePath $app | Out-Null; Write-Log "opened $app" }
        catch { Write-Log "could not open Meetily: $_" }
    } else {
        Write-Log 'Meetily not found — set $RECORDER_APP in config.ps1'
    }
}

function Show-Toast([string]$Title, [string]$Body) {
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        $t = [System.Security.SecurityElement]::Escape($Title)
        $b = [System.Security.SecurityElement]::Escape($Body)
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$t</text><text>$b</text></binding></visual><audio src='ms-winsoundevent:Notification.Default'/></toast>")
        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        # Toasts need a registered app id; Windows PowerShell's own works out of the box.
        $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
    } catch {
        Write-Log "notification failed: $_"
        try {
            Add-Type -AssemblyName System.Windows.Forms
            $icon = New-Object System.Windows.Forms.NotifyIcon
            $icon.Icon = [System.Drawing.SystemIcons]::Information
            $icon.Visible = $true
            $icon.ShowBalloonTip(10000, $Title, $Body, 'Info')
            Start-Sleep -Seconds 10
            $icon.Dispose()
        } catch {}
    }
}

if ($Once) {
    $now = Get-MicUsers
    if ($now.Count -eq 0) { Write-Output 'No app is using the microphone right now.' }
    else { $now | ForEach-Object { Write-Output $_ } }
    exit 0
}

$inMeeting = $false
$on = 0; $off = 0
$app = ''; $started = $null

Write-Log 'watcher started'

while ($true) {
    $hit = Get-MicUsers | Where-Object { $_ -match $MEETING_PATTERN } | Select-Object -First 1

    if ($hit) { $on++; $off = 0 } else { $off++; $on = 0 }

    if (-not $inMeeting -and $on -ge $START_AFTER) {
        $inMeeting = $true
        $app = Get-MeetingLabel $hit
        $started = Get-Date
        Write-Log "START $app ($hit)"
        Open-Meetily
        Show-Toast "$app meeting detected" 'Meetily is open — click Start recording if you want this call.'
    }
    elseif ($inMeeting -and $off -ge $END_AFTER) {
        $inMeeting = $false
        $mins = [int]((Get-Date) - $started).TotalMinutes
        Write-Log "END $app ($mins min)"
        Show-Toast "$app meeting ended" "Stop the recording in Meetily ($mins min)."
    }

    Start-Sleep -Seconds $INTERVAL
}

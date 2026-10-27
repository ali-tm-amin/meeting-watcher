# Removes Meeting Watcher for Windows. Meetily and your recordings are NOT touched.
#   powershell -ExecutionPolicy Bypass -File ~\meeting-watcher\uninstall.ps1
$TaskName = 'IhsanOps Meeting Watcher'
$Dir      = Join-Path $HOME 'meeting-watcher'

Stop-ScheduledTask       -TaskName $TaskName -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path $Dir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host 'Meeting Watcher removed. Meetily and your transcripts are untouched.'

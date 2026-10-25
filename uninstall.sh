#!/bin/bash
# Removes Meeting Watcher. Meetily and your recordings are NOT touched.
LABEL="com.ihsanops.meeting-watcher"

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/$LABEL.plist"
rm -f "$HOME/Library/Logs/meeting-watcher.log" "$HOME/Library/Logs/meeting-watcher.err"
rm -rf "$HOME/meeting-watcher"

echo "Meeting Watcher removed. Meetily and your transcripts are untouched."

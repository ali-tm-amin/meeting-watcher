#!/bin/bash
# Meeting Watcher by IhsanOps — https://ihsanops.ai
# Detects Zoom / Teams calls by checking which apps are using the microphone,
# then opens Meetily and reminds you to start recording. YouTube, podcasts and
# dictation apps never match, so they are ignored. Nothing is recorded by this
# script — you stay in control of what gets recorded.

DIR="$HOME/meeting-watcher"
MIC="$DIR/mic-users"
LOG="$HOME/Library/Logs/meeting-watcher.log"

# Defaults (override any of these in ~/meeting-watcher/config)
INTERVAL=10      # seconds between checks
START_AFTER=2    # meeting app on mic for 2 checks (~20s) = meeting started
END_AFTER=6      # meeting app off mic for 6 checks (~60s) = meeting ended
RECORDER_APP="meetily"
# Zoom = us.zoom.*   Teams = com.microsoft.teams / com.microsoft.teams2
MEETING_PATTERN='^(us\.zoom\.|com\.microsoft\.teams)'

[[ -f "$DIR/config" ]] && source "$DIR/config"

in_meeting=false
on=0
off=0
app=""
started=""

log()    { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"; }
notify() { osascript -e "display notification \"$2\" with title \"$1\" sound name \"Glass\"" >/dev/null 2>&1; }

label() {
  case "$1" in
    us.zoom.*)            echo "Zoom" ;;
    com.microsoft.teams*) echo "Teams" ;;
    *)                    echo "$1" ;;
  esac
}

log "watcher started"

while true; do
  hit=$("$MIC" 2>/dev/null | grep -E "$MEETING_PATTERN" | head -1)

  if [[ -n "$hit" ]]; then
    on=$((on + 1)); off=0
  else
    off=$((off + 1)); on=0
  fi

  if ! $in_meeting && (( on >= START_AFTER )); then
    in_meeting=true
    app=$(label "$hit")
    started=$(date +%s)
    log "START $app"
    open -a "$RECORDER_APP" 2>/dev/null
    notify "$app meeting detected" "Meetily is open — click Start recording if you want this call."
  elif $in_meeting && (( off >= END_AFTER )); then
    in_meeting=false
    mins=$(( ($(date +%s) - started) / 60 ))
    log "END $app (${mins} min)"
    notify "$app meeting ended" "Stop the recording in Meetily (${mins} min)."
  fi

  sleep "$INTERVAL"
done

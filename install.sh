#!/bin/bash
# Meeting Watcher installer by IhsanOps — https://ihsanops.ai
#
#   curl -fsSL https://raw.githubusercontent.com/ali-tm-amin/meeting-watcher/main/install.sh | bash
#
# Safe to run again: it updates an existing install.
set -euo pipefail

REPO="${MW_REPO:-ali-tm-amin/meeting-watcher}"
BRANCH="${MW_BRANCH:-main}"
BASE="https://raw.githubusercontent.com/$REPO/$BRANCH"

DIR="$HOME/meeting-watcher"
LABEL="com.ihsanops.meeting-watcher"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
UID_NUM="$(id -u)"

bold()  { printf "\033[1m%s\033[0m\n" "$*"; }
ok()    { printf "  \033[32m✓\033[0m %s\n" "$*"; }
warn()  { printf "  \033[33m!\033[0m %s\n" "$*"; }
fail()  { printf "  \033[31m✗\033[0m %s\n" "$*"; exit 1; }

echo
bold "Meeting Watcher — by IhsanOps"
echo  "Pops up Meetily the moment a Zoom or Teams call starts."
echo

# ---- 1. Check the Mac -------------------------------------------------------
bold "1/4 Checking your Mac"
[[ "$(uname -s)" == "Darwin" ]] || fail "This only works on macOS."

ver="$(sw_vers -productVersion)"
IFS=. read -r major minor _ <<< "$ver.0"
if (( major < 14 )) || { (( major == 14 )) && (( minor < 2 )); }; then
  fail "macOS 14.2 or newer is needed (you have $ver). Update in System Settings → General → Software Update."
fi
ok "macOS $ver"

# ---- 2. Download the watcher ------------------------------------------------
bold "2/4 Downloading Meeting Watcher"
mkdir -p "$DIR" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"

get() { curl -fsSL "$BASE/$1" -o "$2" || fail "Couldn't download $1. Check your internet connection and try again."; }

get "meeting-watcher.sh" "$DIR/meeting-watcher.sh"
get "uninstall.sh"       "$DIR/uninstall.sh"
get "bin/mic-users"      "$DIR/mic-users"
chmod +x "$DIR/meeting-watcher.sh" "$DIR/uninstall.sh" "$DIR/mic-users"
xattr -d com.apple.quarantine "$DIR/mic-users" 2>/dev/null || true

if ! "$DIR/mic-users" >/dev/null 2>&1; then
  warn "Ready-made detector didn't run — trying to build it on this Mac instead."
  if command -v swiftc >/dev/null 2>&1; then
    get "mic-users.swift" "$DIR/mic-users.swift"
    swiftc -O "$DIR/mic-users.swift" -o "$DIR/mic-users" || fail "Build failed."
  else
    fail "Please run 'xcode-select --install', then run this installer again."
  fi
fi
ok "Installed to ~/meeting-watcher"

# ---- 3. Meetily -------------------------------------------------------------
bold "3/4 Checking for Meetily"
if [[ -d "/Applications/meetily.app" || -d "/Applications/Meetily.app" ]]; then
  ok "Meetily already installed"
elif command -v brew >/dev/null 2>&1; then
  echo "  Installing Meetily with Homebrew (free, open source)…"
  brew install --cask meetily && ok "Meetily installed" || warn "Homebrew install failed — download it from https://meetily.ai"
else
  warn "Meetily isn't installed. Opening the download page — install it, then you're done."
  open "https://github.com/Zackriya-Solutions/meeting-minutes/releases/latest" || true
fi

# ---- 4. Start in the background --------------------------------------------
bold "4/4 Starting Meeting Watcher"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$DIR/meeting-watcher.sh</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>StandardErrorPath</key><string>$HOME/Library/Logs/meeting-watcher.err</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$UID_NUM" "$PLIST"
ok "Running now, and starts automatically when you log in"

# Trigger the one-time notification permission prompt
osascript -e 'display notification "You will get a pop-up like this when a Zoom or Teams call starts." with title "Meeting Watcher is on"' >/dev/null 2>&1 || true

echo
bold "All done. Three quick things in Meetily:"
echo "  1. Open Meetily and allow Microphone + Screen & System Audio Recording"
echo "     (System Settings → Privacy & Security), then quit and reopen it."
echo "  2. Choose Parakeet as the transcription model."
echo "  3. Test it: join https://zoom.us/test — Meetily pops up within ~20 seconds."
echo
echo "  Didn't see a notification? Allow notifications for 'Script Editor'"
echo "  in System Settings → Notifications."
echo
echo "  Log:        cat ~/Library/Logs/meeting-watcher.log"
echo "  Uninstall:  bash ~/meeting-watcher/uninstall.sh"
echo
echo "  Want transcripts filed into your CRM automatically? → https://ihsanops.ai"
echo

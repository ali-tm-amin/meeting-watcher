# Meeting Watcher

**Never forget to record a client call again.**

Meeting Watcher runs quietly on your Mac. The moment a **Zoom** or **Microsoft Teams** call starts, it opens [Meetily](https://meetily.ai) — a free, open-source meeting transcriber — and pops up a reminder. You click record only for the calls you want.

- 🔒 **Private** — everything stays on your Mac. No bots join your calls, nothing is uploaded.
- 🎯 **Smart** — watches which app is using your microphone, so YouTube, podcasts and dictation never trigger it.
- 🙋 **You stay in control** — it reminds, it doesn't record by itself.
- 💸 **Free** — Meeting Watcher and Meetily are both free and open source.

Made by [IhsanOps](https://ihsanops.ai) — *Less admin. More growth.*

---

## Install (about 10 minutes)

**You need:** a Mac on macOS 14.2 or newer.

1. Open **Terminal** (press `⌘ Space`, type *Terminal*, press Enter).
2. Paste this and press Enter:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/ali-tm-amin/meeting-watcher/main/install.sh | bash
   ```

3. Open **Meetily** and allow **Microphone** and **Screen & System Audio Recording** in *System Settings → Privacy & Security*. Quit and reopen Meetily.
4. In Meetily, choose **Parakeet** as the transcription model.
5. Test it: join [zoom.us/test](https://zoom.us/test). Within ~20 seconds Meetily pops up with a notification.

That's it — it starts automatically every time you log in.

## How it works

Every 10 seconds, Meeting Watcher asks macOS which apps are using the microphone. If Zoom or Teams has it for ~20 seconds, a call has started: it opens Meetily and notifies you. When the call has been off the mic for ~1 minute, it reminds you to stop recording.

It never records audio itself and never sends anything anywhere.

## Your transcripts

Every recorded meeting appears in Meetily's sidebar. Copy the transcript into Claude, ChatGPT, Notion or your CRM.

> **Tip:** Let people know you're recording at the start of the call — it's good practice and helps with UK GDPR.

## Settings (optional)

Create `~/meeting-watcher/config` to change the defaults, for example:

```bash
INTERVAL=5          # check every 5 seconds
START_AFTER=3       # wait ~15s before treating it as a meeting
```

Then restart: `launchctl kickstart -k gui/$(id -u)/com.ihsanops.meeting-watcher`

## Troubleshooting

| Problem | Fix |
|---|---|
| No notification appears | System Settings → Notifications → **Script Editor** → allow |
| Meetily doesn't open | Check Meetily is in your Applications folder |
| Nothing happens in a call | Run `~/meeting-watcher/mic-users` during the call and send us the output |
| See what it detected | `cat ~/Library/Logs/meeting-watcher.log` |

## Uninstall

```bash
bash ~/meeting-watcher/uninstall.sh
```

Meetily and your transcripts are not touched.

---

## Want it done for you?

**£250 — 30-minute remote setup.** We install and test everything on your Mac, set the permissions, and show you where your transcripts live.

**Want more?** We can file every transcript into your CRM, Notion or Google Drive automatically — tagged by client, with action items pulled out by AI.

👉 [Book a setup at ihsanops.ai](https://ihsanops.ai)

---

MIT licence. Meetily is © Zackriya Solutions, MIT licence. Not affiliated with Meetily, Zoom or Microsoft.

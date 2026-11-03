# Meeting Watcher — launch video (recording plan, script, shot list)

Target: 4 to 5 minutes after editing. Record 10 to 15 minutes of raw footage; the
waits and retakes get cut. YouTube first, then the same video is the "how to" for
£49 setup clients and the link in the setup email.

Title: **Never forget to record a client call again (free, private, 10-minute setup)**

You do a real install from nothing, on camera, then a real Zoom test call, then a
real summary with Arabic terms explained. Nothing staged, nothing pre-done.

---

## Part A. Before you press record (15 minutes)

### 1. Reset the Mac so the install is real

Run these in Terminal. They keep all your existing meetings safe in a backup folder.

```bash
# 1. Remove Meeting Watcher
bash ~/meeting-watcher/uninstall.sh

# 2. Remove Meetily, keep your meetings and the downloaded models aside
brew uninstall --cask meetily
mv ~/Library/Application\ Support/com.meetily.ai ~/Desktop/meetily-backup
mv ~/Library/Application\ Support/Meetily      ~/Desktop/meetily-backup-templates

# 3. Put the already-downloaded models back so the video doesn't wait on a 1.5 GB download
mkdir -p ~/Library/Application\ Support/com.meetily.ai
cp -R ~/Desktop/meetily-backup/models ~/Library/Application\ Support/com.meetily.ai/models
```

After the video, restore your old meetings:

```bash
cp ~/Desktop/meetily-backup/meeting_minutes.sqlite ~/Library/Application\ Support/com.meetily.ai/
```

If Meetily still downloads a model during the recording, keep recording and keep
talking. The wait gets cut.

### 2. Tidy the screen

- **Focus / Do Not Disturb OFF.** The whole video hinges on a notification appearing. Check the top-right menu bar.
- System Settings → Displays → pick the **"Larger Text"** scaling. Small text is unreadable on a phone.
- Terminal: Cmd + until the font is about 18 pt. Light theme reads better on YouTube.
- One browser window with one tab: `ihsanops.ai/meet`. Close every other tab and window (VS Code, WhatsApp, Mail, Slack).
- Wallpaper: plain. Desktop: empty. Dock: fine as it is.
- Have `zoom.us/test` ready to type when needed.
- Mute your phone.

### 3. Recording tool

QuickTime is enough: **File → New Screen Recording → Options → Microphone: MacBook (or your headset) → Record Entire Screen**. Kap also works (turn on "show mouse clicks").

Mic: a headset or the AirPods is noticeably better than the laptop mic. Record in a quiet room, door closed.

### 4. How to talk

- Say the line, **then** do the click. Don't talk while typing.
- Slower than feels natural. Pause one full second between sentences.
- Made a mistake? Stop, pause two seconds, say the whole line again from the start. Don't stop the recording. I cut the bad take.
- Waiting for a download or a summary? Say "this takes about a minute, I'll cut the wait" and keep going.
- Keep the mouse still when you're not pointing at something.

---

## Part B. The script

Headings are what the viewer sees. Lines in quotes are what you say. **Shot** is what is on screen.

### 0. Hook — 0:00 to 0:15

**Shot:** Zoom window open, you talking. Or just the demo GIF full screen.

> You're twenty minutes into a client call and you realise you never hit record.
> Everything they just told you, gone.
> This fixes that. It's free, nothing leaves your Mac, and I'll install it from
> scratch right now in under ten minutes.

### 1. What it is — 0:15 to 0:45

**Shot:** browser on `ihsanops.ai/meet`. Scroll slowly. Pause on "No subscription. No bot in your call. Nothing leaves your Mac."

> This is Meeting Watcher. A tiny script that watches which app is using your
> microphone. The moment Zoom or Teams takes the mic, it opens Meetily, a free
> open-source transcriber, and pops up a reminder. You press record for the calls
> you want.
>
> Three things. No subscription, no account, no card. No bot joins your call, so
> your client sees nothing. And the transcript is made on your Mac, not uploaded
> anywhere.

### 2. Install — 0:45 to 1:45

**Shot:** click the **Copy** button on the install command on /meet. Cmd-Space, type Terminal, Enter. Paste, Enter.

> Copy the one line from the page. Open Terminal: Command-Space, type Terminal.
> Paste it, press Enter. That's the whole install.

**Shot:** the installer runs. Read the steps aloud as the green ticks appear.

> It checks your Mac. Downloads the script into a folder in your home directory.
> Then it checks for Meetily, and if you don't have it, installs it for you.
> It never asks for your password. The script is open source, link in the
> description, read every line if you like.

**Shot:** the "Summary template installed" tick. Point at it.

> See that line, summary template. Remember it, I'll show you what it does at the end.

**Shot:** the **"Meeting Watcher is on"** notification top-right. Point at it.

> And that's it running. It starts itself every time you log in. You never touch it again.

### 3. Meetily first run — 1:45 to 2:45

**Shot:** open Meetily from Applications. First-run screens.

> Now open Meetily. The first time, macOS asks for two permissions: microphone,
> and screen and system audio recording. That second one is how it hears the other
> people on the call. Say yes to both.

**Shot:** System Settings → Privacy & Security → Microphone (Meetily on), then Screen & System Audio Recording (Meetily on). Quit Meetily, open it again.

> Then quit Meetily and open it again. That restart matters, it won't hear anything
> until you do.

**Shot:** Meetily → Settings → transcription model. Pick **Whisper**.

> One setting. The transcription model. Parakeet is the default, it's fast and
> great for plain English. My calls mix English and Arabic, and Parakeet only
> knows European languages, so I pick Whisper. If you only ever speak English,
> leave Parakeet.

### 4. The live test — 2:45 to 3:45

**Shot:** browser, go to `zoom.us/test`, click Join. Don't touch Meetily.

> Now the real test. I'll join Zoom's test meeting and do nothing else.

**Shot:** wait. Around 15 to 20 seconds later Meetily jumps to the front and the notification appears. Point at it.

> There. Zoom took the microphone, Meeting Watcher noticed, Meetily opened and
> reminded me. I press Start Recording.

**Shot:** click **Start Recording** in Meetily. Then say these four sentences into the Zoom test call, slowly, so the transcript and the summary have Arabic terms to work with:

> Let's confirm the Umrah group booking, inshallah by Friday.
> Brother Yusuf will handle the sadaqah collection this week.
> We need the jummah announcement ready before Thursday.
> And please double-check the zakat calculation before we send it.

**Shot:** the transcript appearing live in Meetily. Point at "inshallah" or "sadaqah" in the text.

> You can see it transcribing live, and because it's Whisper, the Arabic words
> come through properly.

**Shot:** leave the Zoom meeting. Click **Stop Recording** in Meetily. The second notification ("call ended") appears.

> When the call ends, I get a second reminder to stop. Stop recording.

### 5. The summary and the template — 3:45 to 4:30

**Shot:** Meetily, the meeting you just recorded. Click the **Template** button next to Generate Summary. Hover "Standard Meeting Notes + glossary".

> Here's that template from the install. It's already selected, nothing to pick.

**Shot:** click **Generate Summary**. Wait (gets cut). Scroll the summary to a line with brackets, then to the glossary table at the bottom.

> Generate. Takes about a minute on my Mac, I'll cut the wait.
>
> Look at this. Everything in English, but every Arabic word kept and explained:
> sadaqah, voluntary charity. Jummah, the Friday prayer. And a glossary at the
> bottom with the sentence each one came from.
>
> If you speak Urdu or Turkish or Somali on your calls, same thing. If you speak
> only English, you'll just never see this section.

### 6. Close — 4:30 to 5:00

**Shot:** back to `ihsanops.ai/meet`, cursor resting on the install command.

> That's the whole thing. Free, private, and it works by itself from now on.
> Everything is at ihsanops.ai/meet: the install line, the troubleshooting, and
> if you'd rather sit with me for twenty minutes and have it done, there's a
> forty-nine pound option there too.
> Windows version is in beta if you want to be the first to try it.
> Assalamu alaikum.

---

## Part C. After recording

### Send me

- The screen recording file (.mov from QuickTime or .mp4 from Kap). Put it in `~/Movies/meeting-watcher-video/` or tell me where it is.
- Nothing else. Don't trim it yourself.

### What I do with it

Transcribe, cut the silences and the retakes, cut the downloads and the summary wait, add the chapter titles, zoom in on the notification and on the glossary, add captions, and render the final MP4. Plus a 60-second vertical cut (hook, the pop-up, the glossary, the link) for LinkedIn and Shorts.

### Restore your meetings

```bash
cp ~/Desktop/meetily-backup/meeting_minutes.sqlite ~/Library/Application\ Support/com.meetily.ai/
```

Then open Meetily and your old meetings are back. Delete the two backup folders on the Desktop once you've checked.

---

## YouTube

**Title:** Never forget to record a client call again (free, private, 10-minute setup)

**Description:**

Free, open-source, nothing leaves your Mac. Pops up a transcriber the moment a Zoom or Teams call starts.

Install (one line): https://ihsanops.ai/meet
Source code: https://github.com/ali-tm-amin/meeting-watcher
Windows beta: https://ihsanops.ai/meet (PowerShell tab)
£49 done-with-you setup: https://ihsanops.ai/meet

Chapters
0:00 The problem
0:15 What it is
0:45 Install
1:45 Meetily permissions and model
2:45 Live test call
3:45 Summary with Arabic terms explained
4:30 Wrap up

**Tags:** meeting transcription, zoom recording, free meeting notes, meetily, mac automation, muslim business, ihsanops

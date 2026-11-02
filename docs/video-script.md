# Meeting Watcher — install and setup video (script and shot list)

Target: 4 to 5 minutes. YouTube first, then reused as the "how to" for £49 setup clients.
Record screen with Kap or QuickTime at 1920×1080, voice on a separate track if you can
(QuickTime: File → New Screen Recording, pick your mic). Talk slower than feels natural.
Pauses and mistakes are fine: they get cut in the edit.

Title: **Never forget to record a client call again (free, private, 10-minute setup)**

---

## 0. Cold open — 0:00 to 0:20  (camera on you, or just the demo GIF full screen)

> You're twenty minutes into a client call and you realise you never hit record.
> Everything they just told you is gone. This fixes that. It's free, nothing leaves
> your Mac, and the setup takes ten minutes. Let me show you.

**Shot:** the demo GIF (docs/demo.gif) plays while you say it, then cut to your face
or straight to the browser.

## 1. What it is — 0:20 to 1:00  (browser on ihsanops.ai/meet)

> Meeting Watcher is a tiny script that watches which app is using your microphone.
> The moment Zoom or Teams grabs the mic, it opens Meetily, a free open-source
> transcriber, and pops up a reminder. You click record only for the calls you want.
>
> Three things to know. No subscription, no account, no card. No bot joins your
> call, so your clients see nothing. And the transcript is made on your Mac, not
> uploaded anywhere.

**Shot:** scroll /meet slowly; pause on "No subscription. No bot in your call.
Nothing leaves your Mac." Mouse over the three "How it works" steps.

## 2. Install — 1:00 to 2:15  (Terminal)

> Open Terminal: press Command-Space, type Terminal, Enter.
> Copy the command from the page and paste it in. Press Enter.

**Shot:** click Copy on /meet, paste into Terminal, Enter. Let the installer run on
screen. Read the four steps aloud as they appear.

> It checks your Mac, downloads the script to a folder in your home directory,
> checks whether Meetily is installed, and starts the watcher in the background.
> It never asks for your password. If you want to read every line first, the
> installer is open source, link in the description.

**Shot:** when the "Meeting Watcher is on" notification appears top-right, point at
it. If Meetily was not installed, show the download page opening and say:

> If you don't have Meetily yet, it opens the download page. Install it like any
> Mac app, then come back.

## 3. Meetily permissions and model — 2:15 to 3:15  (Meetily + System Settings)

> Open Meetily. First time, macOS asks for microphone and screen-and-system-audio
> permission. Say yes to both, then quit Meetily and open it again. That restart
> matters.

**Shot:** System Settings → Privacy & Security → Microphone, then Screen & System
Audio Recording, Meetily toggled on in both.

> Now the transcription model. In Meetily's Settings pick the model. Parakeet is
> fastest and great for plain English. If your calls mix in other languages,
> choose Whisper instead. I'll show you why in a minute.

**Shot:** Meetily settings page, model dropdown. Pick Parakeet (or Whisper, see §5).

## 4. The test call — 3:15 to 4:00  (zoom.us/test)

> Now test it. Go to zoom.us/test and join. Don't touch anything else.

**Shot:** join the test meeting. Wait. Around twenty seconds later Meetily comes
to the front and the notification appears. Point at it.

> There it is. Zoom took the microphone, Meeting Watcher noticed, Meetily opened
> and reminded me. I click Start Recording and it transcribes on my Mac. When the
> call ends, I get a second reminder to stop.

**Shot:** click record in Meetily, say a sentence, stop, show the transcript appear
in the sidebar.

## 5. Mixed-language calls — 4:00 to 4:40  (Meetily settings, optional section)

> One tip if your calls mix languages. Mine mix English and Arabic. Parakeet
> only knows European languages, so Arabic words come out as nonsense. Whisper
> handles both, so set the model to Whisper. Then the summary: the installer
> already added a template to Meetily. Open any meeting, press Generate Summary,
> and the default template keeps every Arabic word, puts the English meaning in
> brackets, and adds a glossary at the end. Nothing to set up, nothing to type.

**Shot:** Settings → model set to Whisper. Then a meeting: click the Template
button next to Generate Summary to show "Standard Meeting Notes + glossary" is
selected, generate, scroll to a line like "sadaqah (voluntary charity)" and the
glossary table at the bottom.

## 6. Close — 4:40 to 5:00  (back to /meet)

> That's it. It runs every time you log in and you never think about it again.
> Everything's at ihsanops.ai/meet: the install line, troubleshooting, and if
> you'd rather I did it with you on a call, there's a £49 option there too.
> Windows version is in beta if you want to be the first to try it.

**Shot:** /meet page, cursor resting on the install command.

---

## Description (paste under the video)

Free, open-source, nothing leaves your Mac.
Install: https://ihsanops.ai/meet
Source: https://github.com/ali-tm-amin/meeting-watcher
Windows beta: https://ihsanops.ai/meet (PowerShell tab)
£49 done-with-you setup: https://ihsanops.ai/meet

Chapters
0:00 Why
0:20 What it is
1:00 Install
2:15 Meetily permissions and model
3:15 Test call
4:00 Mixed-language calls (English + Arabic)
4:40 Wrap up

## What to send me after recording

- The screen recording (.mov or .mp4) and, if separate, the voice track.
- Nothing else. I transcribe it, cut the silences and retakes, add the chapter
  titles, lower-third captions and the zoom-ins on the notification, and render
  the final MP4 plus a 60-second vertical cut for LinkedIn and Shorts.

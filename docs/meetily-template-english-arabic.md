# Meetily summary template: English calls with Arabic terms

The template itself is [meetily/standard_meeting.json](../meetily/standard_meeting.json). The installer puts it in place; this page explains how it works and how to change it.

## Where Meetily looks for templates

Meetily 0.4.x has no Templates screen in Settings. Instead it scans a folder for `.json` files every time it starts and lists them in the **Template** dropdown next to *Generate Summary* inside a meeting:

| | Folder |
|---|---|
| Mac | `~/Library/Application Support/Meetily/templates/` |
| Windows | `%APPDATA%\Meetily\templates\` |

A file in that folder with the same name as a built-in template replaces it. Ours is called `standard_meeting.json`, so it replaces **Standard Meeting Notes**, which is the template Meetily selects by default. Nothing to click per meeting.

## What the file looks like

```json
{
  "name": "Shown in the dropdown",
  "description": "Shown as a tooltip",
  "sections": [
    {
      "title": "Summary",
      "instruction": "What the model must do for this section",
      "format": "paragraph"
    },
    {
      "title": "Action items",
      "instruction": "One row per task",
      "format": "list",
      "item_format": "| **Owner** | Task | Due |\n| --- | --- | --- |"
    }
  ]
}
```

Rules Meetily enforces: `name`, `description` and at least one section are required; every section needs a `title` and an `instruction`; `format` must be `paragraph`, `list` or `string`; `item_format` is optional and is passed to the model as the shape of each item. A file that breaks a rule is skipped silently, so validate after editing (`python3 -m json.tool file.json` on Mac).

Each section's `instruction` goes into the model's system prompt, which is why the Arabic rule is repeated in every section rather than stated once. Meetily already instructs the model to write in English regardless of the transcript language; the template adds "keep the term, explain it in brackets".

## The transcription side

The template can only explain words that reached the transcript. Parakeet, Meetily's default model, covers 25 European languages and no Arabic, so Arabic words come out as nonsense. Switch to **Whisper** (medium is a good balance) in Meetily's Settings, and leave the language on English: with English forced, Whisper writes Arabic words in Latin letters inside the English text instead of switching to Arabic script mid-sentence.

## Changing it

Edit the JSON, save, quit and reopen Meetily. To go back to Meetily's own template, delete the file. To add a second template instead of replacing the default, give the file a different name, for example `khutbah_notes.json`; it appears in the dropdown as a separate choice.

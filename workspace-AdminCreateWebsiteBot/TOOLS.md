# TOOLS.md - Local Notes

## Your access (granted to this LLM)

You **have access** to:

- **Open and create files:** Use **read**, **write**, **edit** (and **apply_patch**) on files in the workspace. You can open, create, and edit files. Do not say you cannot access files.
- **Open and manipulate files:** Use **read**, **write**, **edit** to open, create, and manipulate files. To open a file on the Mac: **exec** with `open /path/to/file`. **Use the terminal everywhere:** **exec** runs on the user's MacBook — run any terminal command. **Open apps on MacBook:** `open -a "App Name"`. **Open Safari to any page on the internet:** `open -a Safari "https://the-url-here.com"`. Use **MAC_ACCESS_KNOWLEDGE.md** for details.
- **Open the application and run commands:** Use **exec** for any command. Commands run on the user's MacBook **only when you call exec**—always invoke the tool, never only describe. For localhost: call exec for `code /path`, then exec for the dev command (workdir, background: true), then exec for `open http://localhost:PORT`. Or delegate to Main. You have this access; use it when asked.
- **React and React Vite:** Learn and use **REACT_KNOWLEDGE.md** and **VITE_KNOWLEDGE.md**. For **files, localhost, browsers, redirect, commands, Supabase, Vercel, research/fetch**, use **AGENT_TOOLS_KNOWLEDGE.md**. For Mac/open/Safari use **MAC_ACCESS_KNOWLEDGE.md**.

---

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

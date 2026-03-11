# TOOLS.md - Local Notes

## Your access (granted to this LLM)

You **have access** to:

- **Open and manipulate files:** Use **read**, **write**, **edit** (and **apply_patch**) to open, create, and manipulate files in the workspace. To open a file on the Mac in its default app: **exec** with `open /path/to/file`. Do not say you cannot access or manipulate files.
- **Use the terminal everywhere:** Use **exec** to run **any terminal command** on the user's MacBook (gateway = user's machine). You can use the terminal for scripts, servers, opening apps, opening URLs — everywhere.
- **Open apps on the MacBook:** **exec** with `open -a "App Name"` (e.g. `open -a Safari`, `open -a Terminal`).
- **Open Safari and direct the user to any page on the internet:** **exec** with `open -a Safari "https://the-url-here.com"` to open Safari and load that URL. You can direct the user to any webpage. Use it when asked.
- **Open the application and run commands:** Use **exec** for any command (e.g. `npm run dev`, `open http://localhost:5173`). Commands run on the user's MacBook **only when you call exec**—never only describe; always invoke exec. For localhost: call exec for `code /path`, then exec for the dev command (workdir, background: true), then exec for `open http://localhost:PORT`. You have this access; use it when asked.
- **React and React Vite:** Learn and use **REACT_KNOWLEDGE.md** and **VITE_KNOWLEDGE.md**. For **files, localhost, browsers, redirect, commands, Supabase, Vercel, research/fetch from the internet**, use **AGENT_TOOLS_KNOWLEDGE.md**. For Mac/file/app/Safari use **MAC_ACCESS_KNOWLEDGE.md**.

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

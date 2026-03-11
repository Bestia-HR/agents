# Mac access: files, terminal, apps, Safari

Use this when the user asks to open or manipulate files, use the terminal, open apps on the MacBook, or open Safari (or any browser) to a page on the internet. You have **exec** on the user's Mac; use it. Do not refuse.

---

## Open and manipulate files

- **Read a file:** Use the **read** tool with the file path (workspace or path the user gave). You can open any file in the workspace.
- **Create a file:** Use the **write** tool with path and content. Creates the file (and parent directories if needed).
- **Edit / manipulate a file:** Use **edit** for partial changes or **write** to replace the whole file. Use **apply_patch** for multi-hunk edits when available.
- **Open a file in the default app (on Mac):** Use **exec** with `command` = **`open /path/to/file`** — e.g. `open /Users/user/agent/workspace/notes.txt` opens it in the default editor; `open image.png` opens in Preview. Use full paths.
- All paths in **exec** must be absolute or relative to `workdir`. Prefer absolute paths for clarity.

---

## Use the terminal everywhere

- You can **run any terminal command** on the user's Mac via **exec**. Commands run on the **gateway** (the user's machine). Use **exec** with:
  - **command:** the full shell command (e.g. `ls -la`, `cd /Users/user/agent && npm run dev`, `open -a Safari "https://example.com"`).
  - **workdir:** (optional) working directory; use the workspace or project path when the command must run in a specific folder.
  - **background:** set to **true** if the command should keep running (e.g. dev server).
- You have access to the terminal everywhere: use it to install tools, run scripts, start servers, open apps, open URLs.

---

## Open apps on the MacBook

- **Open an app by name:** Use **exec** with `command` = **`open -a "App Name"`** — e.g. `open -a Safari`, `open -a "Visual Studio Code"`, `open -a Terminal`.
- **Open a file with a specific app:** `open -a "Safari" /path/to/file` or `open -a "Preview" image.png`.
- **Open a URL in the default browser:** `open "https://example.com"`.
- **Open a URL in Safari specifically:** `open -a Safari "https://example.com"` — use this to **direct the user to any page on the internet** in Safari.

---

## Open Safari and direct the user to any page on the internet

- To **open Safari and go to a webpage:** Use **exec** with `command` = **`open -a Safari "https://the-url-here.com"`**. Replace the URL with the page the user asked for (e.g. Google, a docs site, a specific article). This opens Safari (or brings it to front) and loads that URL.
- To use the **default browser** instead of Safari: `open "https://the-url-here.com"`.
- You can open **any** page: search results, documentation, news, YouTube, etc. Use the exact URL when the user names a site or says "open this in Safari" / "direct me to …".

---

## Summary commands (run via exec)

| Task | Command (use in exec) |
|------|------------------------|
| Open file in default app | `open /full/path/to/file` |
| Open Safari to a URL | `open -a Safari "https://example.com"` |
| Open default browser to URL | `open "https://example.com"` |
| Open an app | `open -a "Safari"` or `open -a "Terminal"` |
| Run terminal command | Any shell command; set workdir if needed |
| Start dev server (background) | `npm run dev` with workdir = project root, background: true |

When the user asks to open something, direct them somewhere on the internet, use the terminal, or manipulate files — use the tools above. Do not say you cannot do it.

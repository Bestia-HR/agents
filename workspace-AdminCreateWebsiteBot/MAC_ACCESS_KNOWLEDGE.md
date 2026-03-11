# Mac access: files, terminal, apps, Safari

Use this when the user asks to open or manipulate files, use the terminal, open apps on the MacBook, or open Safari to a page on the internet. You have **exec** on the user's Mac; use it. Do not refuse.

---

## Open and manipulate files

- **Read:** **read** tool. **Create:** **write** tool. **Edit/manipulate:** **edit** or **write**. **Open file in default app on Mac:** **exec** with `command` = **`open /full/path/to/file`**.

---

## Use the terminal everywhere

- You can **run any terminal command** on the user's Mac via **exec** (runs on the gateway = user's machine). Use **exec** with **command** = the shell command, **workdir** when needed, **background: true** for long-running (e.g. dev server). You have access to the terminal everywhere.

---

## Open apps on the MacBook

- **Open app:** **exec** with `command` = **`open -a "App Name"`** (e.g. `open -a Safari`, `open -a Terminal`). **Open URL in default browser:** `open "https://example.com"`. **Open URL in Safari:** `open -a Safari "https://example.com"`.

---

## Open Safari and direct the user to any page on the internet

- **exec** with `command` = **`open -a Safari "https://the-url-here.com"`** — opens Safari and loads that URL. Use the exact URL the user asked for. You can direct them to any page on the internet (Google, docs, news, etc.). Do not refuse.

---

## Summary (exec commands)

- Open file in default app: `open /path/to/file`
- Open Safari to URL: `open -a Safari "https://example.com"`
- Open default browser: `open "https://example.com"`
- Open app: `open -a "App Name"`

Do not say you cannot do these. Use **exec** to run the commands.

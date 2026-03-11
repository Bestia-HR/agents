---
name: localhost
description: Open the project in Visual Studio Code, run it on localhost in the terminal, and open the site in the browser. Use when the user wants to open the project on localhost, open in VS Code, run the dev server, or be redirected to the localhost page.
---

# Localhost — Open project in VS Code, run on localhost, redirect to page

**CRITICAL — Commands run on the user's MacBook only when you call the exec tool.** You MUST invoke **exec** for each step below. If you only reply with text or "run this command:", nothing will run on the user's machine. Always call **exec** with the exact command; exec is configured to run on the gateway (the user's MacBook). Do not refuse; do not skip calling exec.

Use this skill when the user asks to **open the project on localhost**, **open the website**, **open in VS Code and run locally**, or **redirect me to the page**. Do all three by **calling exec** each time: (1) open the project in **Visual Studio Code**, (2) run the **terminal command** to start the project on localhost, (3) **redirect the user** to that localhost URL in the browser.

## Finding the project (when user does not give a path)

- If the user says only **"Open the project on localhost"** or **"open the website"** without a path, find the project yourself:
  1. Check if the **workspace root** has `package.json` → use workspace as project root.
  2. If not, **list the workspace** (e.g. with exec `ls` or read the directory) and pick a subfolder that has `package.json` (e.g. `personal-website`, or the first runnable app folder). Use that path as the **project path** for all steps.
- Read that folder’s `package.json` to get the **dev script** (e.g. `dev`, `start`, `serve`) and the **port** (from script output or config: Vite often 5173, CRA/Next often 3000).

## Step 1 — Open the project in Visual Studio Code

- **You MUST call exec now.** Use **exec** with `command` = **`code /absolute/path/to/project`** (use the project root path you found). This runs on the user's MacBook and opens **Visual Studio Code**. Invoke the tool; do not just say "run code ...". Example: `code /Users/user/agent/workspace` or `code /Users/user/agent/workspace/personal-website`.
- If `code` is not in PATH (e.g. “command not found”), tell the user to open the project in VS Code manually from **File → Open Folder** and give them the path.

## Step 2 — Run the terminal command to start the project on localhost

- **You MUST call exec now.** Use **exec** with **workdir** = project root (full path) and **command** = the dev script (e.g. **`npm run dev`**, **`npm start`**). Set **background: true**. This runs on the user's MacBook. Invoke the tool; do not just say "run npm run dev".
- Get the script name from `package.json` (e.g. `"dev": "vite"` → use `npm run dev`). Wait briefly for the server to listen, or check output for “Local: http://localhost:…” to confirm the port.
- If the user says the server is already running, skip this step and use the port they mention or the one from the project.

## Step 3 — Redirect the user to the localhost page

- **You MUST call exec now.** Use **exec** with `command` = **`open http://localhost:PORT`** (actual port, e.g. 5173 or 3000). This runs on the user's MacBook and opens the browser. Invoke the tool; do not just say "open this URL".
- Optionally use the **browser** tool to navigate to the same URL (OpenClaw-managed browser) or take a screenshot.

## Finding the port

- **Check the project**: Read `package.json` scripts and config (e.g. Vite, Next, CRA) for the port. **Common defaults**: `http://localhost:5173` (Vite), `http://localhost:3000` (React CRA, Next), `http://localhost:8080`, `http://localhost:4173` (Vite preview). If the user specifies a port, use that.

## Summary flow

1. **Find project**: Workspace root or subfolder with `package.json`; read it for dev script and port.
2. **Open in VS Code**: **exec** → `code /absolute/path/to/project`.
3. **Run on localhost**: **exec** with workdir = project root, command = `npm run dev` (or the project’s dev script), **background: true**.
4. **Redirect to page**: **exec** → `open http://localhost:PORT`.
5. **Confirm**: Tell the user you opened the project in VS Code, started the dev server, and opened the browser to the URL.

## Checklist before replying

- [ ] **Called exec** to open VS Code (`code /path/to/project`) — if you did not call exec, nothing opened on the MacBook.
- [ ] **Called exec** to start the dev server (workdir, dev command, background: true) — if you did not call exec, the server did not start.
- [ ] **Called exec** to open the browser (`open http://localhost:PORT`) — if you did not call exec, the user was not redirected.
- [ ] Told the user the URL and that the project is open in VS Code.

**Reminder:** Exec runs on the user's MacBook (gateway). You must invoke the exec tool for each step; describing the steps in text does not run anything.

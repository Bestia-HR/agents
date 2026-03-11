# Open and run the project on localhost

Use this when the user asks to **open the project**, **open the website**, **run on localhost**, **view the site locally**, or **open in browser**. You have access to do this; use your **exec** tool. Do not refuse or only give text steps.

## 1. Find the project

- If the user gives a path (e.g. `personal-website`), use that folder as project root.
- If not: check if the **workspace root** has `package.json` → use workspace as project root.
- Else: list the workspace (e.g. `ls` with exec or read the directory) and pick a subfolder that has `package.json` (e.g. `personal-website`). That folder is the **project root** (your `workdir` for exec).

## 2. Get the dev script and port

- **Read** the project’s `package.json` (path: `workdir/package.json`).
- Dev script is usually under `scripts`: `dev`, `start`, or `serve` (e.g. `npm run dev`, `npm start`).
- Port: Vite often uses **5173**; Create React App / Next often use **3000**. Some configs set it in `vite.config.js`, `next.config.js`, or in the script. Default to 5173 for Vite, 3000 for CRA/Next if not stated.

## 3. Start the dev server

- Use **exec** with:
  - **workdir**: the project root (full path, e.g. `/Users/user/agent/workspace/personal-website`).
  - **command**: the dev script (e.g. `npm run dev` or `npm start`).
  - **background**: **true** so the server keeps running.
- Wait a moment for the server to listen (e.g. “Local: http://localhost:5173” in output).

## 4. Open the URL on the user’s machine

- Use **exec** with **command** = **`open http://localhost:PORT`** (replace PORT with the actual port, e.g. 5173 or 3000).
- On macOS this opens the URL in the user’s **default browser** and takes them to the site.
- Run this in the same way you run other exec commands (no parentheses or keyword args in the shell — the exec tool takes a single `command` string).

## 5. Reply to the user

- Say you started the dev server and opened the project, and give the URL (e.g. “Started the dev server and opened the project at http://localhost:5173 — it should have opened in your browser.”).

## Common ports

| Stack / tool | Typical port |
|--------------|---------------|
| Vite        | 5173          |
| Create React App / Next | 3000 |
| Vue CLI     | 8080          |
| Vite preview | 4173         |

## If the server is already running

- Skip step 3. Use the correct port and run **exec** with **command** = **`open http://localhost:PORT`** so the user’s browser opens.

# Open and run the project on localhost

Use this when the user asks to **open the project**, **open the website**, **run on localhost**, **view the site locally**, or **open in browser**. You have access to do this; use your **exec** tool (or delegate to Main if the project is in Main’s workspace). Do not refuse or only give text steps.

## 1. Find the project

- If the user gives a path, use that folder as project root.
- If not: check if the **workspace root** has `package.json` → use workspace as project root.
- Else: list the workspace and pick a subfolder with `package.json` (e.g. `personal-website`). That folder is the **project root** (`workdir` for exec).
- If the project lives in Main’s workspace, delegate to Main with “Open the project on localhost” and/or run the open step yourself after.

## 2. Get the dev script and port

- **Read** the project’s `package.json`. Dev script is usually `dev`, `start`, or `serve` (e.g. `npm run dev`, `npm start`). Port: Vite → 5173; CRA/Next → 3000; or check config. Default 5173 for Vite, 3000 for CRA/Next.

## 3. Start the dev server

- **exec** with **workdir** = project root, **command** = dev script (e.g. `npm run dev`), **background: true**. Wait for the server to listen.

## 4. Open the URL on the user’s machine

- **exec** with **command** = **`open http://localhost:PORT`** (PORT = e.g. 5173 or 3000). On macOS this opens the user’s default browser.

## 5. Reply

- Confirm you started the server and opened the project and give the URL.

## Common ports

- Vite: 5173. CRA/Next: 3000. Vue CLI: 8080. Vite preview: 4173.

## Server already running

- Skip step 3; run **exec** with **command** = **`open http://localhost:PORT`** only.

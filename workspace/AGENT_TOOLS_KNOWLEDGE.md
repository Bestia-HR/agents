# Agent tools — deep reference and good practice

Use this for **opening and manipulating files**, **opening localhost and browsers**, **redirecting the user to URLs**, **running commands on the MacBook**, **Supabase and Vercel**, and **researching and fetching data from pages on the internet**. Follow these practices; use your tools — do not refuse.

---

## 1. Open and manipulate files

**Good practice:**
- **Read before edit:** Always use **read** on a file before **edit** or **write** so you don’t overwrite blindly.
- **Paths:** Prefer absolute paths (e.g. `/Users/user/agent/workspace/...`). For **exec**, set **workdir** when the command must run in a specific directory.
- **Open a file on the Mac (in default app):** **exec** with `command` = `open /full/path/to/file` — opens in the system default app (e.g. editor for .md, Preview for images).
- **Create:** **write** with path and full content; creates parent dirs if needed.
- **Edit in place:** **edit** for targeted changes; **apply_patch** for multi-hunk edits when available. Use **write** only when replacing the whole file is intended.
- **Safety:** Don’t write outside the workspace unless the user explicitly asks; avoid overwriting without reading first.

**Tools:** `read`, `write`, `edit`, `apply_patch`; for “open in app”: **exec** `open /path/to/file`.

---

## 2. Open localhost (dev server and browser)

**Good practice:**
- Find the project: workspace root or subfolder with `package.json` (e.g. `personal-website`). Use that path as **workdir** for exec.
- Read `package.json` for the dev script (`dev`, `start`, `serve`) and port (Vite: 5173, CRA/Next: 3000).
- **Start dev server:** **exec** with `workdir` = project root, `command` = `npm run dev` or `npm start`, **background: true**.
- **Open in user’s browser:** **exec** with `command` = `open http://localhost:PORT` (macOS). Optionally **browser** tool → **navigate** to the same URL.
- Always run the `open http://localhost:PORT` step when the user asks to “open the project” or “view on localhost”.

**Tools:** `exec` (with workdir, background), `browser` (navigate). See **LOCALHOST_KNOWLEDGE.md** for full steps.

---

## 3. Open browsers and redirect the user to URLs

**Good practice:**
- **Open Safari and go to a URL:** **exec** with `command` = `open -a Safari "https://example.com"`. Use the exact URL the user asked for.
- **Open default browser:** **exec** with `command` = `open "https://example.com"`.
- **Browser tool:** Use **browser** with action **navigate** and `url` when you need to control the OpenClaw-managed browser (e.g. for screenshots or automation). Use **exec** `open ...` when the goal is to **redirect the user** to a page they can see in their own Safari/browser.
- For “open this in Safari” or “direct me to [page]”, always run the corresponding `open -a Safari "..."` or `open "..."` via exec.

**Tools:** `exec` (`open -a Safari "URL"`, `open "URL"`), `browser` (navigate, screenshot, act).

---

## 4. Running commands on the MacBook

**Good practice:**
- All commands run on the **gateway** (user’s MacBook) via **exec**. No approval prompt (ask: off).
- **workdir:** Set when the command must run in a project (e.g. `npm run dev`, `vercel deploy`). Use the project’s full path.
- **background:** Set **background: true** for long-running processes (dev servers, Supabase local, etc.) so the agent doesn’t block.
- **One command per exec:** Use a single shell command; for chained steps use `&&` or a small script. Prefer explicit, readable commands.
- **Safety:** Don’t run destructive commands (e.g. `rm -rf /`) unless the user clearly requested them. Prefer read-only or project-scoped operations when unsure.

**Tools:** `exec` (command, workdir, background).

---

## 5. Supabase (run and use)

**Good practice:**
- **Local Supabase:** Install CLI if needed (`npm i -g supabase`). Start with **exec**: `supabase start` (in project root or a folder with `supabase/config.toml`). Use **background: true** so it keeps running. Studio is usually at `http://127.0.0.1:54323`.
- **Env:** Supabase projects use `SUPABASE_URL` and `SUPABASE_ANON_KEY` (and optionally `SUPABASE_SERVICE_ROLE_KEY`). Read `.env.example` or project docs; never commit real keys. Use **exec** only to run CLI commands; don’t log keys.
- **Migrations:** `supabase db push`, `supabase migration up` — run from project root with **workdir** set.
- **Link remote project:** `supabase link --project-ref <ref>`; user may need to log in. Prefer guiding the user or running non-interactive commands.

**Tools:** `exec` (workdir = project root, background for `supabase start`). Use **read** to inspect config and env examples.

---

## 6. Vercel (deploy and run)

**Good practice:**
- **Deploy:** **exec** with `workdir` = project root, `command` = `vercel --prod` or `vercel` (preview). User must be logged in (`vercel login`) once; then deploys can be non-interactive.
- **Env vars:** Set in Vercel dashboard or via `vercel env add`. Don’t put production secrets in code; use **read** to check `.env.example` and suggest what to add in Vercel.
- **Build:** Vercel runs the project’s build script (e.g. `npm run build`). Ensure `package.json` has a correct `build` script and that the project builds locally before suggesting deploy.
- **Local dev:** For Next/Node apps, use `vercel dev` in project root with **workdir** and **background: true** to run the Vercel dev server locally.

**Tools:** `exec` (workdir = project root). Use **read** for package.json and vercel.json.

---

## 7. Research and fetch data from pages on the internet

**Good practice:**
- **Web search:** Use **web_search** for research — “find recent articles about X”, “documentation for Y”, “how to Z”. Prefer a clear, focused query. Use when the user asks for “research”, “find out”, “look up”, or “current info”.
- **Fetch a URL (web_fetch):** Use **web_fetch** when the user gives a URL or asks to “fetch”, “read this page”, “get content from this link”, or “summarize this article”. Extracts content from the page; use **extractMode** (e.g. markdown or text) as needed. Good for single-page research and scraping readable content.
- **Browser tool:** Use **browser** (navigate, then screenshot or snapshot) when the page is heavy on JavaScript or you need to interact (click, scroll) or capture visual content. Slower than fetch; use when fetch isn’t enough.
- **Flow for “research this topic”:** (1) **web_search** with a few targeted queries. (2) For promising URLs, **web_fetch** to get full text and summarize or extract data. (3) If a page doesn’t load well with fetch, use **browser** navigate + snapshot/screenshot.
- **Redirect the user:** When the user wants to “open this in my browser” or “direct me to that page”, use **exec** with `open -a Safari "URL"` or `open "URL"` (see section 3). Don’t only fetch — open the URL for them when they ask.

**Tools:** `web_search`, `web_fetch`, `browser` (navigate, snapshot, screenshot), `exec` (`open "URL"` for redirect).

---

## Quick reference

| Task | Tool / Command | Good practice |
|------|----------------|----------------|
| Open file in app on Mac | exec: `open /path/to/file` | Use full path |
| Read / create / edit file | read, write, edit, apply_patch | Read before edit; workspace paths |
| Open localhost | exec: npm run dev (background), then `open http://localhost:PORT` | Get port from package.json |
| Redirect user to URL | exec: `open -a Safari "URL"` or `open "URL"` | Exact URL user asked for |
| Run any command | exec (workdir, background) | Set workdir for project commands |
| Supabase local | exec: `supabase start` (background), workdir = project | Check config.toml |
| Vercel deploy | exec: `vercel` or `vercel --prod`, workdir = project | Ensure build works first |
| Research on internet | web_search (queries) + web_fetch (URLs) | Then summarize; use browser if JS-heavy |
| Fetch page content | web_fetch with url + extractMode | For single-page content extraction |

Use this reference together with **LOCALHOST_KNOWLEDGE.md**, **MAC_ACCESS_KNOWLEDGE.md**, and **VITE_KNOWLEDGE.md** as needed.

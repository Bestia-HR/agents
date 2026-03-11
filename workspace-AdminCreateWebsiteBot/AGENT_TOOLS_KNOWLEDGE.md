# Agent tools — deep reference and good practice

Use this for **opening and manipulating files**, **opening localhost and browsers**, **redirecting the user to URLs**, **running commands on the MacBook**, **Supabase and Vercel**, and **researching and fetching data from pages on the internet**. Follow these practices; use your tools — do not refuse. Delegate to Main when the project is in Main's workspace.

---

## 1. Open and manipulate files

**Good practice:** Read before edit; prefer absolute paths. **Open in app on Mac:** exec `open /full/path/to/file`. **Create/edit:** write, edit, apply_patch. Don't overwrite without reading first. **Tools:** read, write, edit, apply_patch; exec `open /path/to/file`.

---

## 2. Open localhost

**Good practice:** Find project (package.json in workspace or subfolder). **Start dev server:** exec with workdir = project root, command = `npm run dev` or `npm start`, **background: true**. **Open in browser:** exec `open http://localhost:PORT`. See **LOCALHOST_KNOWLEDGE.md**. **Tools:** exec (workdir, background), browser (navigate).

---

## 3. Open browsers and redirect user to URLs

**Good practice:** **Safari:** exec `open -a Safari "https://example.com"`. **Default browser:** exec `open "https://example.com"`. For "direct me to [page]", always run the appropriate open command. **Tools:** exec (`open -a Safari "URL"`, `open "URL"`), browser (navigate, screenshot).

---

## 4. Running commands on the MacBook

**Good practice:** All via **exec** on gateway (user's MacBook). Set **workdir** for project commands; **background: true** for long-running (servers). One command per exec; use `&&` for chains. **Tools:** exec (command, workdir, background).

---

## 5. Supabase

**Good practice:** **Local:** exec `supabase start` in project root, **background: true**. Studio often at http://127.0.0.1:54323. Env: SUPABASE_URL, SUPABASE_ANON_KEY; never commit keys. **Migrations:** `supabase db push` from project root. **Tools:** exec (workdir, background); read config and .env.example.

---

## 6. Vercel

**Good practice:** **Deploy:** exec `vercel` or `vercel --prod`, workdir = project root. Ensure build works first. Env in Vercel dashboard or `vercel env add`. **Local dev:** `vercel dev` with workdir and background. **Tools:** exec (workdir); read package.json, vercel.json.

---

## 7. Research and fetch data from internet pages

**Good practice:** **Research:** web_search (targeted queries), then web_fetch (URLs) to get page content; summarize. **Fetch a page:** web_fetch with url + extractMode (markdown/text). **JS-heavy or interact:** browser (navigate, snapshot, screenshot). **Redirect user:** exec `open "URL"` or `open -a Safari "URL"`. **Tools:** web_search, web_fetch, browser, exec (open URL).

---

## Quick reference

| Task | Tool / Command |
|------|----------------|
| Open file in app | exec: `open /path/to/file` |
| Read/create/edit file | read, write, edit, apply_patch |
| Open localhost | exec: npm run dev (background), then `open http://localhost:PORT` |
| Redirect to URL | exec: `open -a Safari "URL"` or `open "URL"` |
| Run command | exec (workdir, background) |
| Supabase local | exec: `supabase start` (background), workdir = project |
| Vercel deploy | exec: `vercel` or `vercel --prod`, workdir = project |
| Research / fetch page | web_search + web_fetch; browser if JS-heavy |

Use with **LOCALHOST_KNOWLEDGE.md**, **MAC_ACCESS_KNOWLEDGE.md**, **VITE_KNOWLEDGE.md**.

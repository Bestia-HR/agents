---
name: create-repo-and-launch
description: Create a new GitHub repository, clone it locally, optionally scaffold with Next.js or Vite, and open the project on localhost. Use when the user wants to create a new repo, start a new project on GitHub, or "create repo and open on localhost".
---

# Create repo and open on localhost

Use this skill when the user asks to **create a new repository**, **create a repo and open it on localhost**, **start a new project on GitHub and run it locally**, or similar. The script creates the repo on GitHub, clones it to `~/websites/NAZWA`, optionally scaffolds with Next.js (default) or Vite, then runs the dev server and opens the browser.

## Requirements

- **GitHub:** Either **GitHub CLI** (`gh`) logged in (`gh auth login`), or **GITHUB_TOKEN** in `.env` in the agent project root (Settings → Developer settings → Personal access tokens; scope `repo`).
- **Workdir for exec:** The directory that contains `openclaw.json` and `scripts/` (agent project root). The script loads `.env` from there.

## Command

From the agent project root:

```bash
./scripts/create-repo-and-launch.sh NAZWA_REPO [--template next|vite|empty] [--private] [--no-launch]
```

- **NAZWA_REPO** — name of the new repo (and folder under `~/websites/`).
- **--template next** (default) — scaffold Next.js, then start dev server and open browser.
- **--template vite** — scaffold Vite (React + TypeScript), then launch.
- **--template empty** — only create repo and clone; no scaffold, no localhost (or use **--no-launch** to skip opening browser after scaffold).
- **--private** — create a private repository.
- **--no-launch** — do not run the dev server / open browser after scaffold.

## Examples (exec)

| User request | workdir | command |
|--------------|--------|--------|
| "Create repo my-app and open on localhost" | agent root | `./scripts/create-repo-and-launch.sh my-app` |
| "New GitHub repo 'dashboard' with Vite, run locally" | agent root | `./scripts/create-repo-and-launch.sh dashboard --template vite` |
| "Create private repo project-x" | agent root | `./scripts/create-repo-and-launch.sh project-x --private --no-launch` |

After a successful run, the user gets a new repo on GitHub, a local copy in `~/websites/NAZWA_REPO`, and (unless `--no-launch` or `--template empty`) the site opens at http://localhost:3000 (or next free port).

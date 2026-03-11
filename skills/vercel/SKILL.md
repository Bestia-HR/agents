---
name: vercel
description: Deploy and run projects on Vercel. Use when the user asks to deploy to Vercel, run Vercel dev, set up Vercel, add Vercel env vars, or use the Vercel CLI.
---

# Vercel — Deploy and run

Use this skill when the user asks to **deploy to Vercel**, **run Vercel**, **use Vercel dev**, **set up Vercel**, or work with the Vercel CLI. Use **exec** with workdir = project root. See **AGENT_TOOLS_KNOWLEDGE.md** section 6 for full good practice.

## Good practice

- **Build first:** Ensure the project has a valid `build` script in `package.json` and that it builds locally (e.g. `npm run build`) before suggesting or running deploy.
- **Env vars:** Don’t put production secrets in code. Use **read** to check `.env.example`; suggest adding vars in the Vercel dashboard or via `vercel env add`. Never log or commit real secrets.

## Deploy

- **exec** with **workdir** = project root (folder with `package.json` or `vercel.json`), **command** = `vercel --prod` (production) or `vercel` (preview).
- User must be logged in once (`vercel login`). If deploy fails with auth, guide the user to run `vercel login` in the terminal.
- After deploy, Vercel prints the deployment URL; share it with the user.

## Local dev (Vercel dev server)

- For Next.js or other Vercel-supported frameworks: **exec** with **workdir** = project root, **command** = `vercel dev`, **background: true**. This runs the Vercel dev server locally. Tell the user the local URL (often http://localhost:3000).

## Env vars and config

- **read** `package.json` for the build script; **read** `vercel.json` if present for project config.
- Env vars: set in Vercel dashboard (Project → Settings → Environment Variables) or via `vercel env add`. Suggest which vars are needed based on `.env.example` or docs.

## Summary

| Task      | Command (exec, workdir = project root)   |
|-----------|------------------------------------------|
| Deploy prod | `vercel --prod`                        |
| Deploy preview | `vercel`                             |
| Local dev | `vercel dev` (background: true)         |

Use **read** for package.json and vercel.json when needed.

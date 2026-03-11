---
name: supabase
description: Run and use Supabase locally and in the cloud. Use when the user asks to start Supabase, run Supabase locally, set up Supabase, run migrations, link Supabase project, or work with Supabase CLI or Studio.
---

# Supabase — Run and use

Use this skill when the user asks to **run Supabase**, **start Supabase locally**, **set up Supabase**, **run migrations**, **link Supabase project**, or work with the Supabase CLI or Studio. Use **exec** with workdir and background as needed. See **AGENT_TOOLS_KNOWLEDGE.md** section 5 for full good practice.

## Good practice

- **Read before run:** Check for `supabase/config.toml` or Supabase-related files in the project. Use that folder as **workdir** for exec.
- **Never commit or log** real keys (SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY). Use **read** only to inspect `.env.example` or docs; suggest env vars without echoing secrets.

## Start Supabase locally

- **exec** with **workdir** = project root (folder containing `supabase/` or `supabase/config.toml`), **command** = `supabase start`, **background: true**.
- If the CLI is missing: `npm i -g supabase` (or guide the user to install). Then run `supabase start` again.
- Studio is usually at **http://127.0.0.1:54323**. Tell the user they can open it with `open http://127.0.0.1:54323` or you can run that via exec.

## Environment and keys

- Supabase projects use `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and optionally `SUPABASE_SERVICE_ROLE_KEY`. Read `.env.example` or project docs; suggest adding these to `.env` (and never commit real values). Don’t run commands that print secrets.

## Migrations

- From project root: **exec** with **workdir** = project root, **command** = `supabase db push` or `supabase migration up` as appropriate for the project.

## Link remote project

- **exec** with **workdir** = project root, **command** = `supabase link --project-ref <ref>`. If login is required, guide the user to run `supabase login` once.

## Summary

| Task           | Command (exec, workdir = project root) |
|----------------|----------------------------------------|
| Start local    | `supabase start` (background: true)   |
| Open Studio    | `open http://127.0.0.1:54323`           |
| Push migrations| `supabase db push`                     |
| Link project   | `supabase link --project-ref <ref>`    |

Use **read** to inspect `supabase/config.toml` and `.env.example` when needed.

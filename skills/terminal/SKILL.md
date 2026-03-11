---
name: terminal
description: Run terminal commands on the user's MacBook. Use when the user asks to run a command, execute a script, run something in the terminal, install a package, start a server, or run any shell command on their machine.
---

# Terminal — Run commands on the MacBook

Use this skill when the user asks to **run a command**, **execute a script**, **run something in the terminal**, **install a package**, **start a server**, or run any **shell command** on their Mac. All commands run via **exec** on the gateway (user’s MacBook). See **AGENT_TOOLS_KNOWLEDGE.md** section 4 and **MAC_ACCESS_KNOWLEDGE.md** for good practice.

## Good practice

- **workdir:** Set **workdir** to the project or folder where the command must run (e.g. `npm run dev`, `vercel deploy`, `supabase start`). Use the full path.
- **background:** Set **background: true** for long-running processes (dev servers, `supabase start`, `vercel dev`) so the agent doesn’t block.
- **One command per exec:** Use a single shell command; for chained steps use `&&` or a small script. Prefer clear, readable commands.
- **Safety:** Don’t run destructive commands (e.g. `rm -rf /`) unless the user clearly asked. Prefer read-only or project-scoped commands when unsure.

## Tools

- **exec** with **command** = the full shell command (e.g. `npm run build`, `ls -la`, `open -a Safari "https://example.com"`).
- **workdir** = path to the project or directory when the command must run in a specific place.
- **background** = true for servers or long-running processes.

## Examples

| User ask           | exec (workdir, command, background)                    |
|--------------------|--------------------------------------------------------|
| Run dev server     | workdir = project root, command = `npm run dev`, background = true |
| Install deps       | workdir = project root, command = `npm install`        |
| Open Safari to URL | command = `open -a Safari "https://..."`               |
| List directory     | workdir = path, command = `ls -la`                    |

Use **AGENT_TOOLS_KNOWLEDGE.md** and **MAC_ACCESS_KNOWLEDGE.md** for open files, open apps, and redirect to URLs.

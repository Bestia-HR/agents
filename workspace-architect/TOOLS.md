# Tools

**Execute commands (all bots):** You have **exec** — you can run any terminal command on the user's MacBook (npm install, npm run dev, open URL, scripts, etc.). Commands run only when you call the exec tool; do not refuse. Use workdir for project paths; use background: true for long-running servers.

You have **sessions_list**, **sessions_send**, **sessions_history** to delegate to other agents. You have **read**, **write**, **edit**, **exec** for files and commands. Use exec to run npm install, npm run dev, open http://localhost:PORT. Commands run on the user's MacBook when you call exec.

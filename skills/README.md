# Custom skills (optional)

This folder is referenced in `openclaw.json` under `skills.load.extraDirs`. You can add custom OpenClaw skills here so the agent can call extra tools (e.g. other APIs).

Web search and URL fetch are already provided by OpenClaw’s built-in **web_search** and **web_fetch** skills when enabled in the main config.

## Loaded skills

| Skill | Description |
|-------|-------------|
| **website** | Frontend coding — HTML, CSS, JavaScript, React |
| **backend** | Backend and APIs — server logic, DB, auth |
| **files** | Open, read, create, and edit files in the workspace |
| **localhost** | Open the project on localhost (dev server + browser) |
| **terminal** | Run terminal commands on the user’s MacBook |
| **supabase** | Run Supabase locally, migrations, link project |
| **vercel** | Deploy and run projects on Vercel |
| **web-research** | Research on the internet and fetch page content |

**If new skills don’t show up:** OpenClaw builds the list of skills when it starts and (with `watch: true`) when files change. The list is also cached per **session**. So after adding new skills:

1. **Restart OpenClaw** so it rescans `skills/` and includes the new ones.
2. **Start a new chat** (new session) so that session gets the updated skills list. Old chats may keep the previous list until you restart and open a new conversation.

To add a new skill, see [Creating skills](https://docs.openclaw.ai/tools/creating-skills) and use:

```bash
npx openclaw-cli init-skill my-skill-name
```

Then place the skill in this `skills/` directory.

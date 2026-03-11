# 9 Web development agents

Single Telegram bot → all messages go to **Project Architect**, which delegates to specialists.

**After switching to this setup:** Restart the gateway (`./run-gateway.sh`). If you had the old 2 agents (Coder/Researcher), you may want to clear sessions so the Architect gets a fresh session: run `./clear-sessions.sh` (if you have it) or delete `.openclaw-state/agents/*/sessions/*` then restart the gateway.

| # | Agent ID     | Name              | Model             | Role |
|---|--------------|-------------------|-------------------|------|
| 1 | architect    | Project Architect  | qwen3:8b        | Master orchestrator; plans and delegates (requires tool support) |
| 2 | ui-designer  | UI/UX Designer     | qwen3:8b         | Design systems, Tailwind, layouts |
| 3 | frontend     | Frontend Developer | qwen2.5-coder:7b | React, Next.js, TypeScript, components |
| 4 | backend      | Backend Developer  | qwen2.5-coder:7b | API routes, Node.js, PostgreSQL, Stripe |
| 5 | database     | Database Architect | qwen2.5-coder:7b | Prisma, PostgreSQL, Redis |
| 6 | seo          | SEO Specialist     | qwen3:8b         | Metadata, schema markup, Core Web Vitals |
| 7 | reviewer     | Code Reviewer      | qwen2.5-coder:7b | Code quality, security, performance |
| 8 | debugger     | Debugger           | qwen2.5-coder:7b | Fix errors and bugs |
| 9 | writer       | Technical Writer   | qwen3:8b         | README, API docs, deployment |

**Tech stack:** React / Next.js, Node.js, REST APIs, PostgreSQL, Tailwind CSS.

**Commands (send to the bot):**
- `/build [description]` — full website build
- `/component [description]` — React component
- `/api [description]` — API route
- `/schema [description]` — Prisma schema
- `/fix [error]` — debugger
- `/review [code]` — code review
- `/seo [page]` — SEO metadata
- `/ui [description]` — design system
- `/docs [project]` — documentation
- `/ecommerce [store]` — full e-commerce pipeline
- `/projects` — list built websites

**First time:** `mkdir -p ~/websites` (or the Architect will direct outputs there.)

**After a build:** Save files to `~/websites/[project-name]/`. Then run:
```bash
cd /Users/user/agent/websites && ./launch-project.sh ~/websites/project-name
```
Or: `python3 manager.py start project-name`

**Ports:** Script uses first free port from 3000–3005 (avoids conflict with OpenClaw on 3000).

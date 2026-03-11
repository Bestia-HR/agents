# AI models (Ollama) — 9 web dev agents

| Agent             | Model             | Role              | Ollama pull              |
|-------------------|-------------------|-------------------|--------------------------|
| **Project Architect** (default) | Qwen 3 8B         | Orchestration (needs tool support) | `ollama pull qwen3:8b`   |
| **UI/UX Designer** | Qwen 3 8B         | Design systems    | `ollama pull qwen3:8b`   |
| **Frontend Developer** | Qwen 2.5 Coder 7B | React/Next.js     | `ollama pull qwen2.5-coder:7b` |
| **Backend Developer** | Qwen 2.5 Coder 7B | APIs, Node, DB   | (same) |
| **Database Architect** | Qwen 2.5 Coder 7B | Prisma, PostgreSQL | (same) |
| **SEO Specialist** | Qwen 3 8B         | Metadata, schema  | `ollama pull qwen3:8b`   |
| **Code Reviewer** | Qwen 2.5 Coder 7B | Review, quality   | (same) |
| **Debugger**      | Qwen 2.5 Coder 7B | Fix errors        | (same) |
| **Technical Writer** | Qwen 3 8B       | Documentation     | `ollama pull qwen3:8b`   |

**Note:** The **Architect** must use a model that supports **tool calling** (e.g. qwen3:8b). DeepSeek-R1 8B does not support tools in Ollama, so it cannot be used for the Architect.

**First-time setup:**
```bash
ollama pull qwen3:8b
ollama pull qwen2.5-coder:7b
```

Then start the gateway: `./run-gateway.sh`

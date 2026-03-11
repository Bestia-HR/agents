# Local Ollama optimized for coding

This project tunes the **local Ollama** model (llama3.2) and agents for **coding** on this device.

## Config changes (openclaw.json)

| Setting | Value | Why |
|--------|--------|-----|
| **temperature** | 0.2 | More deterministic output, better for code. |
| **maxTokens** (model params) | 8192 | Longer code blocks and multi-file snippets in one reply. |
| **maxTokens** (provider model) | 8192 | Same limit at provider level. |
| **thinkingDefault** | medium | Balance between quality and speed for code tasks. |
| **alias** | Llama 3.2 (local, coding) | Indicates coding-focused use. |

## Agent instructions (workspace)

- **Agent A (main):** Instructions stress **precision** (read before edit), **complete runnable code**, use of knowledge files (HTML, JS, React, etc.), and suggesting tests/lint. Optimized for Macbotd and local Ollama.
- **Agent B (AdminCreateWebsiteBot):** Same coding focus; backend directly, frontend via delegation to Main; complete code and tests when relevant.

## Summary

- **Lower temperature** → more consistent, less random code.
- **Higher maxTokens** → longer code replies without truncation.
- **Coding-focused AGENTS.md** → both agents prioritize read-before-edit, runnable code, and tests/lint.

Restart the gateway after changes: `openclaw gateway stop` then `./run-gateway.sh`.

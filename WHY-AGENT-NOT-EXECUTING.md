# Why the agent doesn't execute commands

## Main reason: the model replies with text instead of calling the exec tool

**Commands run on your MacBook only when the agent invokes the exec tool.** If the agent only writes something like "Run: `npm run dev`" or "I'll open that for you" in its reply, it is **not** executing anything—it is just text. The agent must **emit a tool call** to `exec` with the command; then OpenClaw runs that command on the gateway (your MacBook).

### What was changed

- **AGENTS.md** (both workspaces): Added a top section *"Why commands don't run"* that tells the model it must call the exec tool, not only reply with text.
- **IDENTITY.md** (both workspaces): Added a line that to run commands the agent must call the exec tool; text-only replies do not run anything.
- **localhost skill** and **TOOLS.md** already stress that the agent must invoke exec.

After editing these files, **restart the gateway** and use a **new chat** so the updated instructions are loaded.

## Other checks

1. **Gateway running on your MacBook**  
   For exec to run on your machine, the OpenClaw gateway must be running there:
   ```bash
   ./run-gateway.sh
   ```
   If you use Telegram, the process that handles the bot must have the gateway reachable (same machine or configured gateway URL).

2. **Config**  
   In `openclaw.json` you have:
   - `tools.exec.host`: `"gateway"` → exec runs on the gateway (your MacBook when gateway runs there).
   - `tools.exec.ask`: `"off"` → no approval step.

3. **Model behavior**  
   Some smaller models (e.g. 7B) are less reliable at tool use. If the agent still only replies with text after the changes above, try:
   - A new conversation (new session).
   - A more explicit prompt, e.g.: "Run this exact command on my Mac and reply with its output: `echo hello`."
   - A larger or more capable model if available in your setup.

## Quick test

From the project root (with gateway and Ollama running):

```bash
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json" OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
openclaw agent --agent main --message "Run this command and reply with only its output: echo EXEC_WORKS" --thinking off --timeout 60
```

If the reply contains `EXEC_WORKS`, the agent is calling exec and commands are running. If not, the agent is still replying with text only; use a new chat so it gets the updated instructions.

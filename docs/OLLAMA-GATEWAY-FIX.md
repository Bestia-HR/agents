# Fix: "Ollama requires authentication to be registered as a provider"

If you see:
```text
Unknown model: ollama/llama3.2. Ollama requires authentication to be registered as a provider.
Set OLLAMA_API_KEY="ollama-local" (any value works)
```

**Cause:** The gateway process didn’t have `OLLAMA_API_KEY` in its environment when it started (e.g. it was started from another directory or without loading `.env`).

**Fix:**

1. **Use the project script so `.env` is loaded:**
   ```bash
   cd /Users/user/agent
   openclaw gateway stop
   ./run-gateway.sh
   ```
   `run-gateway.sh` loads `.env` and exports `OLLAMA_API_KEY` so Ollama is registered.

2. **Confirm `.env` has:**
   ```bash
   OLLAMA_API_KEY=ollama-local
   ```

3. **If you start the gateway some other way** (e.g. `openclaw gateway` in another terminal), set the variable first:
   ```bash
   export OLLAMA_API_KEY=ollama-local
   export OPENCLAW_CONFIG_PATH=/Users/user/agent/openclaw.json
   export OPENCLAW_STATE_DIR=/Users/user/agent/.openclaw-state
   openclaw gateway --port 18789 --verbose
   ```

After restarting the gateway with `OLLAMA_API_KEY` set, Ollama is registered and the agents can use `ollama/llama3.2` (and fall back to Groq when needed).

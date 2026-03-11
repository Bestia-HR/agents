# "LLM request timed out" — why and how to fix

## Do this to fix it

1. **Pre-load the model** (reduces cold-start timeout): in a terminal, run:
   ```bash
   export OLLAMA_KEEP_ALIVE=-1
   ollama run llama3.2
   ```
   Leave it open so the model stays in memory.

2. **Restart the gateway** so it uses the current config (maxTokens 8192, OLLAMA_KEEP_ALIVE from run-gateway.sh):
   ```bash
   ./run-gateway.sh
   ```

3. **If it still times out**: in `openclaw.json` lower `maxTokens` to **4096** in both:
   - `models.providers.ollama.models[0].maxTokens`
   - `agents.defaults.models["ollama/llama3.2"].params.maxTokens`

4. **When sending from a script**: use a long timeout, e.g. `OPENCLAW_AGENT_TIMEOUT=600 ./send-portfolio-prompt-macbotd.sh`.

---

## Why it happens

The **LLM request** (the call from OpenClaw to Ollama to generate a reply) has its own timeout. If the model takes longer than that to respond, you see **"LLM request timed out"**.

Common causes:

1. **Slow first token** — Ollama loading the model from disk or generating the first token can take 30–90+ seconds for large models or cold start.
2. **Very long replies** — With high `maxTokens` (e.g. 65536), generating a long answer takes a long time on CPU/GPU. The LLM request may time out before the model finishes.
3. **Default timeout too short** — OpenClaw may use a default (e.g. 60–120 s) for the actual HTTP request to the model. That’s too low for slow or long-running Ollama calls.

## What we changed in this project

**Reliable fix: lower maxTokens.** OpenClaw often uses a **hardcoded or short default** (e.g. 60–120 s) for the LLM HTTP request. The config keys `requestTimeoutMs` / `connectTimeoutMs` on the Ollama provider **may be ignored** in many versions. So the fix that works is:

- **maxTokens: 8192** (provider + agent params) — replies finish sooner so they complete before OpenClaw’s internal LLM timeout. Lower to 4096 if it still times out.
- **OLLAMA_KEEP_ALIVE=-1** — set in `run-gateway.sh` (and in the env when you run Ollama) so the model stays in memory and cold start doesn’t trigger a timeout.

We set **unlimited**-style timeouts in **openclaw.json** under **models.providers.ollama**:

- **connectTimeoutMs: 86400000** (24 hours) — time allowed to connect to Ollama.
- **requestTimeoutMs: 86400000** (24 hours) — time allowed for the full LLM request.

**If your OpenClaw version does not support these keys**, the gateway may report "Unrecognized keys" and ignore them. Then run `openclaw doctor --fix` to remove them, and rely on: pre-loading the model (`./warm-ollama.sh`) and lower `maxTokens` (e.g. 4096).

**Agent-level** timeout remains high (**timeoutSeconds: 86400** or 24 h) so the overall run doesn’t time out.

## If it still times out

1. **Lower maxTokens** — So each reply finishes sooner. In `openclaw.json` set e.g. `agents.defaults.models["ollama/llama3.2"].params.maxTokens` to **8192** or **16384** instead of 65536. Same in `models.providers.ollama.models[0].maxTokens` if you want a hard cap.
2. **Keep Ollama model loaded** — Avoid cold start by keeping the model in memory:
   ```bash
   export OLLAMA_KEEP_ALIVE=-1
   ollama run llama3.2
   ```
   Or set `OLLAMA_KEEP_ALIVE=-1` in the environment where you start the gateway.
3. **Faster hardware / smaller model** — Use a smaller or quantized model (e.g. 3B instead of 8B) or ensure Ollama is using GPU (Metal on Mac) so generation is faster.
4. **Check gateway and CLI** — When running a script, use a high `--timeout` (e.g. `OPENCLAW_AGENT_TIMEOUT=7200`). The gateway must stay running; if the script times out, increase the script’s timeout or run without gateway (e.g. safe script) so the run uses embedded mode and the agent timeout (7200 s) applies.

## Summary

| Cause | Fix |
|-------|-----|
| Default LLM timeout too low | Set `requestTimeoutMs` (and optionally `connectTimeoutMs`) on the Ollama provider. |
| Very long replies (high maxTokens) | Lower `maxTokens` (e.g. 8192–16384). |
| Cold start / model loading | Increase `connectTimeoutMs`; use `OLLAMA_KEEP_ALIVE=-1`. |
| Agent run timeout | Already 7200 s; increase further if needed. |

Restart the gateway after changing config: `./run-gateway.sh`.

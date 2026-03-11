# Why the local LLM doesn’t respond fast (and what to do)

## Main reasons it feels slow

1. **Cold start**  
   The first message after starting (or after the model was unloaded) can take 30–90+ seconds because Ollama loads the model from disk into RAM/VRAM. Later messages are faster while the model stays loaded.

2. **Running on CPU**  
   On Mac, Ollama uses **Metal (GPU)** when possible. If it’s using CPU only (e.g. no Metal support or wrong build), generation is much slower. Check Activity Monitor: “Ollama” should show GPU usage when generating.

3. **Model size**  
   **llama3.2** 8B needs more compute per token than smaller models (e.g. 3B, 1B). Bigger = smarter but slower on the same hardware.

4. **Long replies**  
   With `maxTokens: 4096`, the model can generate up to 4096 tokens per reply. Short answers (e.g. “Hi!”) finish quickly; long ones take proportionally longer.

5. **Long context**  
   Long conversation history increases the number of tokens sent each time, so each request does more work and takes longer.

---

## What we already did in this project

- **thinkingDefault: "off"** — no extra “thinking” step, so replies start sooner.
- **streaming: "partial"** — you see text as it’s generated instead of waiting for the full reply.
- **OLLAMA_KEEP_ALIVE=-1** in `run-gateway.sh` — tells Ollama to keep the model loaded so the next message doesn’t hit a cold start.
- **Warm-up** in `run-gateway.sh` — one short request when the gateway starts so the first user message is less likely to hit a cold start.
- **maxTokens: 4096** — limits reply length so answers don’t run forever.

---

## What you can do to get faster replies

### 1. Keep the model loaded (avoid cold start)

Before using the bot, run and leave open:

```bash
./warm-ollama.sh
```

Or in another terminal:

```bash
export OLLAMA_KEEP_ALIVE=-1
ollama run llama3.2
```

Then start the gateway. The first “hi” will be much faster.

### 2. Use a smaller/faster model (trade quality for speed)

If you care more about speed than quality, switch to a smaller model:

```bash
ollama pull llama3.2:1b
# or
ollama pull llama3.2:3b
```

Then in `openclaw.json` change the model id from `llama3.2` to e.g. `llama3.2:3b` (in `models.providers.ollama.models[0].id` and `agents.defaults.model.primary` and `agents.defaults.models`). Smaller models give quicker first token and higher tokens/second.

### 3. Give Ollama more resources (if you have them)

- Close other heavy apps so Ollama gets more CPU/RAM.
- On Mac with Apple Silicon, Ollama uses Metal by default; no extra config needed.

### 4. Lower maxTokens for “quick chat” only (optional)

For very short answers you could lower `maxTokens` (e.g. to 1024) in `openclaw.json` under `agents.defaults.models["ollama/llama3.2"].params.maxTokens` and `models.providers.ollama.models[0].maxTokens`. We keep 4096 so the bot can still give longer replies when needed.

---

## Summary

| Cause              | Fix |
|--------------------|-----|
| Cold start         | Run `./warm-ollama.sh` or `ollama run llama3.2` with `OLLAMA_KEEP_ALIVE=-1` before using the bot. |
| CPU-only / no GPU  | Use a Mac build with Metal; check GPU usage in Activity Monitor. |
| Model too big      | Try a smaller model (e.g. `llama3.2:3b` or `llama3.2:1b`). |
| Long replies       | Already capped with maxTokens; for quick chat you can lower it. |
| Long context       | Start a new chat or clear sessions (`./clear-sessions.sh`) to shorten context. |

Restart the gateway after any config change: `./run-gateway.sh`.

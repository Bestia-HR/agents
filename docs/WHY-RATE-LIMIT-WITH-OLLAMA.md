# Why you still see rate limit when you installed Ollama (ollama-local)

The **rate limit message in OpenClaw is from Groq**, not from Ollama. Ollama has no API rate limit.

What happens:

1. Your config uses **Ollama first** (`ollama/llama3.2`), then **Groq as fallback**.
2. OpenClaw tries **Ollama**.
3. **Ollama fails** (not registered, not running, model missing, or connection error).
4. OpenClaw **falls back to Groq**.
5. **Groq** returns "API rate limit reached" (its 6k TPM limit).
6. You see that rate limit message even though you installed Ollama.

So the limit you see is Groq’s. Ollama isn’t successfully handling the request, so the request goes to Groq and hits its limit.

---

## What to check so Ollama is used (and you avoid the limit)

| Check | What to do |
|-------|------------|
| **1. Ollama is running** | Open the Ollama app, or in a terminal run `ollama serve`. Leave it running. |
| **2. Model is pulled** | Run once: `ollama run llama3.2` (downloads the model if needed). |
| **3. Gateway sees OLLAMA_API_KEY** | Start the gateway **from the project** so `.env` is loaded: `cd /Users/user/agent` then `./run-gateway.sh`. Don’t start the gateway from another directory or without loading `.env`. |
| **4. .env has the key** | In `/Users/user/agent/.env` you should have: `OLLAMA_API_KEY=ollama-local`. |
| **5. Restart after changes** | After fixing any of the above: `openclaw gateway stop` then `./run-gateway.sh`. |

---

## Quick test

In a terminal:

```bash
# Is Ollama responding?
curl -s http://127.0.0.1:11434/api/tags
```

If you get JSON with a list of models (e.g. `llama3.2`), Ollama is running. If you get "Connection refused", start Ollama first.

---

## Summary

- **Rate limit in OpenClaw = Groq’s limit.**  
- You see it because **Ollama isn’t succeeding**, so OpenClaw uses Groq and hits its limit.  
- Fix the Ollama side (running app, model pulled, `OLLAMA_API_KEY` when starting the gateway, restart), then requests will use Ollama and you won’t hit the Groq rate limit for those requests.

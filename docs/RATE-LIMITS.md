# API rate limits — what to do when you hit them

When OpenClaw shows **rate limit** or **413/429** errors from Groq (or another provider), use these steps.

## Why you see “rate limit” with only a few API calls (e.g. 14)

Groq’s limit is **tokens per minute (TPM)**, not “number of calls”.

- **Free tier:** 6,000 **input tokens per minute**.
- One request can be **10k–13k+ tokens** (system prompt + SOUL/AGENTS + full chat history + tool results).
- So **even 1–2 calls** can exceed 6,000 TPM if each request is large. The dashboard may show “14 API calls” but the **token count** in that minute is what triggers the limit.

So: **low call count does not mean you’re under the limit** — the **size** of each request (long threads, high thinking) pushes you over TPM.

## What you’re seeing (Groq free tier)

- **413** – “Request too large … TPM: Limit 6000, Requested 12984”  
  The **input** (prompt + history) for that request is over Groq’s **6,000 tokens per minute** limit. One big request is enough.

- **429** – Too many requests (or too many tokens) in a short time.

## What we changed in this project

1. **Fallback model**  
   If Groq returns 413/429, OpenClaw tries **Ollama** (`ollama/llama3.2`) next.  
   Make sure Ollama is installed and running (`ollama run llama3.2` once) and `OLLAMA_API_KEY=ollama-local` is in `.env`.

2. **Lower concurrency**  
   `maxConcurrent: 2` and `subagents.maxConcurrent: 4` so fewer requests hit the API at once.

3. **Shorter replies**  
   Groq model `maxTokens` set to **2048** so replies stay smaller and the next request is less likely to exceed 6k input tokens.

## What you can do

| Action | How |
|--------|-----|
| **Use Ollama when Groq fails** | Keep Ollama running; fallback is already set in `openclaw.json`. |
| **Reduce context size** | Start a **new chat** for a new topic so history is shorter. |
| **Use two Groq keys** | Agent A uses `GROQ_API_KEY`, Agent B uses `GROQ_API_KEY_AGENT_B` in `.env` to spread load. |
| **Upgrade Groq** | [Groq Console → Billing](https://console.groq.com/settings/billing) — Dev Tier gives higher TPM. |
| **Check status** | `openclaw models status` and `openclaw status --deep` to see cooldowns and provider state. |

## Quick checks

```bash
# Restart gateway so config (fallbacks, maxConcurrent) is applied
openclaw gateway stop
./run-gateway.sh

# Sync API keys from .env
bash setup-auth.sh
```

If you still see 413, the **conversation is too long**. Start a new chat or use a thread with fewer messages.

---

## How to get around the API call limit

| Option | What to do | Effect |
|--------|------------|--------|
| **1. Use Ollama (no limit)** | Install [Ollama](https://ollama.ai), run `ollama run llama3.2`, add `OLLAMA_API_KEY=ollama-local` to `.env`, and set **primary** model to `ollama/llama3.2` in `openclaw.json` with Groq as fallback. | Traffic goes to your Mac; no Groq TPM limit. |
| **2. More Groq API keys** | Create extra keys at [console.groq.com](https://console.groq.com). Add them as extra auth profiles (e.g. `groq:key2`) in the agent auth store or use separate keys per agent (you already use two: Agent A and Agent B). | Spreads load across keys; each key has its own TPM. |
| **3. Upgrade Groq** | [Groq Console → Billing](https://console.groq.com/settings/billing) → Dev or paid tier. | Higher TPM (e.g. 30k+), fewer 413/429. |
| **4. Use less tokens** | New chat for new topics; set `thinkingDefault` to `low` or `off`; keep threads short. | Stays under 6k TPM per request more often. |
| **5. Wait and retry** | Limits are per minute. Wait 1–2 minutes, then send again or run your script. | Simple; no config change. |

# Free alternatives to paid search API keys (for OpenClaw)

Your agent can use **web search** without paying. Here are options that work with OpenClaw.

---

## 1. **Gemini (Google)** — recommended free option

- **Cost:** Free, no credit card.
- **What you get:** Google Search grounding: the model searches the web and returns answers with citations.
- **Limits:** Free tier (e.g. 60 RPM, generous daily tokens; see [Google AI](https://ai.google.dev/gemini-api/docs)).
- **Setup:**
  1. Go to [Google AI Studio](https://aistudio.google.com/apikey).
  2. Sign in, create an API key, copy it.
  3. In your project `.env` set: `GEMINI_API_KEY=your_key_here`.
- **In OpenClaw:** With `GEMINI_API_KEY` set, OpenClaw will use Gemini for `web_search` automatically (before Brave). Or set explicitly in `openclaw.json`:
  ```json
  "tools": {
    "web": {
      "search": {
        "enabled": true,
        "provider": "gemini"
      }
    }
  }
  ```

---

## 2. **Brave Search API**

- **Cost:** 2,000 free queries/month, no credit card.
- **What you get:** Structured search results (title, URL, snippet).
- **Setup:** [brave.com/search/api](https://brave.com/search/api/) → create key → set `BRAVE_API_KEY=...` in `.env`.

---

## 3. **Perplexity via OpenRouter** (no credit card, but not free)

- **Cost:** OpenRouter supports crypto/prepaid; no credit card required.
- **What you get:** AI-synthesized answers with citations (Sonar models).
- **Setup:** [openrouter.ai](https://openrouter.ai/) → add credits → set `OPENROUTER_API_KEY=...`. In config set `provider` to `"perplexity"`.

---

## Other free options (not built into OpenClaw)

| Option      | Notes |
|------------|--------|
| **SearXNG** | Self-hosted metasearch; no API key. OpenClaw has a [feature request](https://github.com/openclaw/openclaw/issues/15068) for SearXNG; not yet built-in. Public instances often disable JSON API. |
| **OpenSerp** | Free, open-source SerpAPI alternative; self-hosted, no key. Would require custom integration. |
| **Searlo**   | 3,000 free credits, no card; would require custom integration. |

---

## Summary

- **Easiest free path:** Get a **Gemini API key** from [aistudio.google.com/apikey](https://aistudio.google.com/apikey), put it in `.env` as `GEMINI_API_KEY=...`. Your agent will use it for web search when the key is present.
- **Also free:** Brave Search (2,000 queries/month) if you set `BRAVE_API_KEY`.

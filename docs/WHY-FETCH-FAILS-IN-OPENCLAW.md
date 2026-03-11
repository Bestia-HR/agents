# Why fetch fails in OpenClaw

When **web_fetch** (or a generic “Fetch failed” message) fails in OpenClaw, it’s usually one of the following. Use this to debug and fix.

---

## 1. “Fetch failed” in the dashboard / WebChat

**Symptom:** You see a generic **“Fetch failed”** in the UI even though the gateway is running.

**Common cause:** This often refers to **gateway/dashboard** requests (e.g. auth or loading data), not the **web_fetch** tool.

- **Gateway token mismatch** – Dashboard was opened with a wrong or stale token.
- **Rate limiting** – Too many failed auth attempts; wait or clear site storage.

**What to do:**

- Open the dashboard with the correct token: `http://127.0.0.1:18789/#token=YOUR_TOKEN`.
- Clear site data for the dashboard URL and reload.
- Restart the gateway and try again.

---

## 2. web_fetch tool fails (agent can’t load a URL)

**Symptom:** The agent tries to fetch a URL (e.g. for docs or a page) and **web_fetch** returns an error or empty content.

**Portfolio / “create a website” prompts:** The agent may call web_fetch (e.g. for Google Fonts or a reference). If that request fails, you see “fetch failed”. Add to the prompt: “Do not use web_fetch or web_search; generate from your knowledge only.” The file `prompts/portfolio-fullstack-single-file.txt` already includes this.

### A. Private / local URLs blocked (SSRF protection)

**Cause:** OpenClaw blocks requests to private/internal addresses (localhost, 127.0.0.1, 10.x, 192.168.x) by default.

**Fix:** If you need to fetch from localhost or an internal URL, enable private network access in `openclaw.json`:

```json
"tools": {
  "web": {
    "fetch": {
      "enabled": true,
      "allowPrivateNetwork": true
    }
  }
}
```

Restart the gateway after changing config.

### B. Timeout

**Cause:** The site is slow or large; default timeout (e.g. 30s) is exceeded.

**Fix:** Increase timeout in `openclaw.json`:

```json
"fetch": {
  "enabled": true,
  "timeoutSeconds": 60
}
```

### C. Site blocks the request (403, bot blocking)

**Cause:** The server rejects the default User-Agent or blocks non-browser clients.

**Fix:** You can override the User-Agent in config (see [OpenClaw web tools](https://docs.openclaw.ai/tools/web)). Some sites will still block; for those, use the **browser** tool or another method.

### D. SSL / certificate errors

**Cause:** Invalid or self-signed certs, or TLS issues.

**Fix:** Ensure the URL uses valid HTTPS. For internal servers with self-signed certs, OpenClaw may not support disabling verification; use a URL with a valid cert or a local proxy that does.

### E. Empty or incomplete content (JavaScript-heavy pages)

**Cause:** **web_fetch** does a plain HTTP GET and does **not** run JavaScript. Many modern sites render content with JS, so the fetched HTML has little or no main content.

**Fix:**

- Prefer URLs that return static HTML (docs, simple pages).
- Optional: set up **Firecrawl** (API key) so OpenClaw can use it as a fallback for JS-rendered pages. See [OpenClaw Firecrawl](https://docs.openclaw.ai/tools/firecrawl) and add `FIRECRAWL_API_KEY` or `tools.web.fetch.firecrawl.apiKey`.

### F. Redirect to a blocked URL

**Cause:** The target URL redirects to a private/internal host; OpenClaw blocks that by default.

**Fix:** Use the final public URL if possible, or enable `allowPrivateNetwork` only if you need and trust the internal target.

---

## 3. web_search fails (different from web_fetch)

**Symptom:** Search doesn’t work or returns an error.

**Cause:** The configured **search provider** (e.g. Gemini or Brave) needs an API key.

**Your config:** `tools.web.search.provider` is `"gemini"`. So **web_search** uses **GEMINI_API_KEY** (from `.env` or config).

**Fix:**

- Ensure `GEMINI_API_KEY` is set in `.env` (or in the gateway’s environment).
- Start the gateway from the project directory so `.env` is loaded: `./run-gateway.sh`.
- If you use Brave instead, set `BRAVE_API_KEY` and set `provider` to `"brave"`.

---

## Quick checklist

| Issue | Check / fix |
|-------|-------------|
| “Fetch failed” in dashboard | Token, clear storage, restart gateway |
| Fetch to localhost/internal URL | Add `allowPrivateNetwork: true` under `tools.web.fetch` |
| Fetch times out | Increase `timeoutSeconds` in `tools.web.fetch` |
| Empty content from a modern site | Use a static URL or Firecrawl |
| Search not working | Set `GEMINI_API_KEY` (or Brave key) and restart gateway with env loaded |

After changing `openclaw.json`, restart the gateway so the new config is applied.

---

## Disabling web_fetch (stops "fetch failed" entirely)

The agent can still try to use web_fetch if the **skill** is enabled, even when you ask it not to use the internet. To stop "fetch failed" completely, disable both:

1. **Tool:** `tools.web.fetch.enabled: false`
2. **Skill:** `skills.entries.web_fetch.enabled: false`

**In this project** both are set to **false**. The agent no longer has the web_fetch skill available, so it cannot call it. **web_search** stays enabled for current info. Restart the gateway after changing config.

---

## Applied in this project (when fetch was enabled)

To reduce fetch failures when enabled, `openclaw.json` had:

- **`timeoutSeconds: 120`** – 2 minutes per URL so slow sites don’t time out as often.
- **`maxRedirects: 5`** – follow redirects.
- **`userAgent`** – set to a common Chrome UA so some sites that block bots are less likely to reject the request.

Note: `allowPrivateNetwork` is not supported in OpenClaw 2026.3.1; private/localhost URLs remain blocked by default. Use only public URLs for web_fetch.

If fetch still fails (e.g. SSL or strict bot blocking), the agent can continue using its training or web_search instead; for tasks that don’t need a specific URL, you can say “don’t use web_fetch” in the prompt.

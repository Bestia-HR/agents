# Where OpenClaw shows API rate limit

OpenClaw does **not** have a dedicated “API rating” or “rate limit” dashboard. You see rate limits in these places:

---

## 1. In the chat (when a request fails)

When Groq (or another provider) returns **413** or **429**, the failure appears **in the conversation**:

- **Telegram / WebChat:** The bot may not reply, or you see an error message (e.g. “Request failed”, “rate limit”, or the provider’s message).
- The **content** of the error (e.g. “TPM: Limit 6000, Requested 12984”) comes from the provider; OpenClaw surfaces it in the reply or as a failed turn.

So the “API rating” / rate limit often shows up **as a failed or missing reply** in the same place you chat (Telegram group or WebChat).

---

## 2. In the gateway terminal / logs

When you run the gateway with `./run-gateway.sh` or `openclaw gateway`, the **terminal** and **logs** show provider errors:

```bash
openclaw logs --follow
```

You’ll see 413/429 or “rate limit” in the log output when a request is rejected.

---

## 3. Usage and status (tokens / cost, not “rate limit” per se)

OpenClaw can show **usage** (tokens, cost), which is related to why you hit limits:

| Where | How |
|-------|-----|
| **WebChat** | In the chat: type **`/status`** for a status card (session, model, tokens, cost). **`/usage cost`** for a cost summary. **`/usage tokens`** or **`/usage full`** for per-response usage. |
| **CLI** | `openclaw status --usage` — per-provider usage. `openclaw channels list` — can include usage snapshot. |

That’s **usage**, not a live “rate limit remaining” number. The **limit** itself is enforced by Groq; when you exceed it, you see the failure in the chat or logs (sections 1 and 2).

---

## 4. Groq’s own dashboard (not OpenClaw)

**API call count** and **quota/limits** (e.g. “14 calls”, TPM) are shown in **Groq’s** dashboard, not in OpenClaw:

- [console.groq.com](https://console.groq.com) → usage / API / billing.

OpenClaw does not display “how many API calls left” or “current TPM”; it only shows **usage after the fact** (tokens/cost) and **errors** when a request is rate-limited (413/429 in chat or logs).

---

## Summary

| What you mean | Where it shows |
|---------------|----------------|
| **“Rate limit” error (413/429)** | In the **chat** (failed or missing reply) and in **gateway logs** (`openclaw logs --follow`). |
| **Usage (tokens / cost)** | **WebChat:** `/status`, `/usage cost`, `/usage tokens`, `/usage full`. **CLI:** `openclaw status --usage`, `openclaw channels list`. |
| **API call count / quota** | **Groq Console** (console.groq.com), not in OpenClaw. |

So in OpenClaw, “API rating” / rate limit appears **when a request fails** (in the chat and in logs), plus you can see **usage** with `/status` and `/usage` in WebChat or the CLI; the actual quota/limit numbers are on Groq’s side.

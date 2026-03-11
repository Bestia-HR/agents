# Bot doesn’t answer “hi” in Macbotd — checklist

Use this when the bot doesn’t reply to “hi” (or any message) in the Telegram group.

## 1. Telegram: privacy mode (most common)

If **privacy is enabled**, the bot **never sees** plain “hi” — only commands, @mentions, and replies to the bot.

**Fix:** For **each** bot in the group (Agent A and Agent B):

1. Open Telegram → **@BotFather**
2. Send **`/setprivacy`**
3. Choose the bot (Main / Agent A, then AdminCreateWebsiteBot / Agent B)
4. Set to **Disable**

Do this for **both** bots. Then send “hi” again in Macbotd.

## 2. Gateway must be running

The gateway is what receives Telegram updates and runs the agents.

```bash
./run-gateway.sh
```

Leave this terminal open. If the gateway isn’t running, no bot will answer.

## 3. Ollama running and model loaded (avoids timeout)

If the model is cold, the first “hi” can hit an LLM timeout and you get no reply.

**Option A – pre-load the model (recommended):**

```bash
./warm-ollama.sh
```

Leave that running. In **another** terminal run `./run-gateway.sh`.

**Option B – at least have Ollama running:**

```bash
ollama serve   # if not already running
```

## 4. You’re messaging the right place

- Send “hi” in the **group Macbotd** (not in a private chat with the bot, unless you’ve set that up).
- Your Telegram user ID must be in `groupAllowFrom` (config already has `8455470574`).

## 5. After changing anything

- Restart the gateway: stop it (Ctrl+C), then `./run-gateway.sh` again.

---

## Quick checklist

| Check | Action |
|-------|--------|
| Privacy off for **both** bots | @BotFather → `/setprivacy` → Disable for each bot |
| Gateway running | `./run-gateway.sh` in a terminal |
| Model warm (optional) | `./warm-ollama.sh` in another terminal |
| Ollama running | `ollama serve` or `ollama run llama3.2` |

If the bot still doesn’t answer, check the gateway terminal for errors (e.g. “LLM request timed out”, Telegram errors).

# Bots don’t respond in Telegram group Macbotd

Use this checklist when the bots don’t reply to your messages in Macbotd.

## Quick fix (most common)

| # | Check | Fix |
|---|--------|-----|
| 1 | **Gateway running?** | `cd /Users/user/agent` then `./run-gateway.sh`. Leave it open. |
| 2 | **Ollama running?** | Start Ollama or `ollama run llama3.2`. Test: `curl -s http://127.0.0.1:11434/api/tags` returns JSON. |
| 3 | **Bot sees your message?** | @mention the bot (e.g. `@YourBotName hi`) or @BotFather → `/setprivacy` → select bot → **Disable**. |

After any config change, restart the gateway (Ctrl+C then `./run-gateway.sh`).

---

## 0. Use a proper @mention (when you "write his name")

When you write the bot's name in the chat, Telegram only sends that message to the bot if either:

- You **@mention** the bot: type `@` and choose the bot from the list (e.g. `@YourBotName hello`). That creates a real mention; the bot receives the message.
- Or the bot's **privacy mode is turned off** (see below), so it receives all group messages.

If you only type the bot's name as plain text (e.g. `YourBotName hello`) and privacy mode is **on**, Telegram does **not** send that message to the bot, so it never responds.

**What to do:** Use the @ button or type `@` and pick the bot from the list, then your message. Example: `@DoximaFullStackBot what's the weather?`

## 0b. Turn off Telegram bot privacy mode (optional but recommended)

By default, Telegram bots only receive: /commands, @mentions, and replies to the bot. To have the bot receive **all** messages in the group:

1. Open Telegram and message **@BotFather**.
2. Send **`/setprivacy`**.
3. Select the bot (e.g. your main bot or AdminCreateWebsiteBot).
4. Choose **Disable**.

Do this for **both** bots if you have two. After this, the bots receive every group message; OpenClaw still filters by `groupAllowFrom` and `requireMention`.

## 1. Gateway must be running

The gateway receives Telegram messages and runs the agents. If it’s not running, nothing will reply.

```bash
cd /Users/user/agent
./run-gateway.sh
```

Leave this terminal open. You should see something like: `Gateway starting at http://127.0.0.1:18789`.

## 2. Ollama must be running

Both agents use local Ollama. If Ollama isn’t running, the gateway may receive the message but the agent will fail before replying.

- Start the Ollama app, or run: `ollama serve` (and ensure `llama3.2` is pulled: `ollama run llama3.2`).
- Quick check: `curl -s http://127.0.0.1:11434/api/tags` should return JSON.

## 3. Config allows you and the group

In `openclaw.json` under `channels.telegram.accounts` (main and admin):

- **groupAllowFrom** must include your Telegram user ID (e.g. `["8455470574"]`).
- **groupPolicy** is set to `"open"` so the group is allowed.
- For Macbotd, **requireMention** is `false`, so you don’t need to @mention the bot.

If you use a different Telegram account, add that account’s numeric ID to `groupAllowFrom` (and optionally `allowFrom`).

## 4. Both bots are in the group

- Agent A uses the **main** bot token; Agent B uses the **admin** bot token.
- In Telegram, open Macbotd → Add members → add both bots (search by their @username from BotFather).

## 5. Restart after config changes

After editing `openclaw.json` or `.env`, restart the gateway:

```bash
# In the terminal where the gateway is running: Ctrl+C, then:
./run-gateway.sh
```

## 6. Check logs for errors

In another terminal:

```bash
cd /Users/user/agent
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json" OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
openclaw logs --follow
```

Send a message in Macbotd and watch the logs. Look for:

- Incoming Telegram message (e.g. `peer=group:-5049131940`).
- Any error (e.g. “Ollama requires authentication”, “rate limit”, “Unknown model”).
- If you see “Agent failed before reply”, the next lines usually explain why (e.g. Ollama not reachable).

## 7. Test from CLI (no Telegram)

To confirm the agents and Ollama work without Telegram:

```bash
cd /Users/user/agent
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json" OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

openclaw agent --agent main --message "Reply with only: OK" --thinking off
```

If this works, the problem is likely Telegram/gateway (steps 1–6). If this fails, fix Ollama or model config first.

## Summary

| Check              | What to do                                      |
|--------------------|--------------------------------------------------|
| Gateway            | Run `./run-gateway.sh` and keep it running       |
| Ollama             | Start Ollama and have `llama3.2` available       |
| Your user ID       | In `groupAllowFrom` (e.g. `8455470574`)          |
| Bots in group      | Both bots added to Macbotd                       |
| After config edit  | Restart gateway                                 |
| Errors             | `openclaw logs --follow` while you send a msg   |

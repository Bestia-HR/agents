# How to authorize the AI agent in a Telegram group

## Quick steps

1. **Use your numeric Telegram user ID** (not @username).  
   Your ID is already in config: `8455470574`.  
   To add more people, use their numeric IDs in `allowFrom` and optionally `groupAllowFrom`.

2. **Add the bot to the group**  
   In Telegram: open the group → Add members → search for your bot (e.g. @DoximaFullStackBot) → Add.

3. **Mention the bot to get a reply**  
   In the group, type e.g. `@DoximaFullStackBot What's the weather?`  
   The agent only replies when **mentioned** (config: `groups."*".requireMention: true`).

4. **Restart the gateway** after changing `openclaw.json`.

---

## Config in `openclaw.json`

| Setting | Purpose |
|--------|--------|
| **`channels.telegram.allowFrom`** | Who can use the bot in **DMs**. Use **numeric** IDs only, e.g. `["8455470574"]` or `["tg:8455470574"]`. |
| **`channels.telegram.groupAllowFrom`** | Who can trigger the bot in **groups** (and slash commands). Same format. If omitted, group behavior may fall back to `allowFrom`. |
| **`channels.telegram.groupPolicy`** | `"open"` = any group can use the bot (when mentioned). `"allowlist"` = only groups listed in `groups` are allowed. |
| **`channels.telegram.groups."*"`** | With `groupPolicy: "open"`, `"*"` means “all groups”; `requireMention: true` means the bot only replies when @mentioned. |

Your current setup: **open** to all groups, reply only when **mentioned**, and only for user ID `8455470574`.

---

## Finding someone’s Telegram user ID

- **From OpenClaw:** Gateway running → `openclaw logs --follow` → have them send a message to the bot → look for `from.id` in the log.
- **From Telegram API:**  
  `curl "https://api.telegram.org/bot<BOT_TOKEN>/getUpdates"`  
  Then have them send a message and run again; look for `"from":{"id":123456789,...}`.
- **From a bot:** They can message @userinfobot or @getidsbot (less private).

---

## Restrict to specific groups only

To allow only certain groups:

1. Set `groupPolicy` to `"allowlist"`.
2. Add group IDs to `channels.telegram.groups`:

```json
"groupPolicy": "allowlist",
"groups": {
  "-5194180791": { "requireMention": true }
}
```

Group IDs are negative numbers; you see them in gateway logs when someone writes in the group (e.g. `peer=group:-5194180791`).

---

## Fix “Invalid allowFrom entry” / “non-numeric”

Telegram auth needs **numeric** user IDs. Replace any @username (e.g. `DLAYAMC7`) with the numeric ID (e.g. `8455470574`). You can run:

```bash
openclaw doctor --fix
```

(with `TELEGRAM_BOT_TOKEN` in `.env`) to try auto-resolving usernames to IDs.

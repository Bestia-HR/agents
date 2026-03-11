# Built-in commands and “bot doesn’t see my messages”

## What was going on

When you use a **built-in command** (e.g. `/status`, `/usage`, `/help`) in the Macbotd group:

- The **response** was coming from a **different session** (the “slash” session).
- In that session the bot **does not see** your normal group messages — it only sees that you ran the command.
- So it felt like the bot “responds in another variation” and “doesn’t see my messages”.

That’s because with **native** Telegram slash commands, OpenClaw uses an **isolated session** for commands. Your group chat lives in the **group session**; the command runs in the **slash session**, so the bot has no group history there.

## What we changed

In `openclaw.json` we set:

```json
"channels": {
  "telegram": {
    "commands": {
      "native": false
    },
    ...
  }
}
```

With **native** set to **false** for Telegram:

- Commands like `/status` are handled as **text** commands.
- They run in the **same session** as your group chat.
- The bot **sees** your group messages (same conversation), and the reply appears in the **same** chat.

So: same place, same context, bot “sees” your messages.

## After changing config

Restart the gateway so the new config is used:

```bash
# Stop the gateway (Ctrl+C in its terminal), then:
./run-gateway.sh
```

## Summary

| Setting | Effect |
|--------|--------|
| `commands.native: true` (default) | /status etc. use a separate “slash” session → bot doesn’t see group messages there. |
| `commands.native: false` | /status etc. run in the group session → bot sees your messages; response in the same chat. |

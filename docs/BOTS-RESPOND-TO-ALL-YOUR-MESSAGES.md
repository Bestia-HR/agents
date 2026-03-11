# Bots respond to all your messages

So that **both bots reply to every message you send** in the group (no need to @mention):

## 1. OpenClaw config (already set)

In `openclaw.json` this is already configured:

- **requireMention: false** for the group (and `"*"`), so the bots don’t require an @mention to reply.
- **groupAllowFrom: ["8455470574"]** for both `main` and `admin`, so only your messages are allowed to trigger replies (you can add more IDs if needed).
- **groupPolicy: "open"** so the group is allowed.

So on the OpenClaw side, the bots are set to respond to **all** messages from you.

## 2. Telegram: disable privacy for both bots

By default, Telegram only sends the bot:

- /commands (e.g. `/start`, `/status`)
- Messages that @mention the bot
- Replies to the bot’s messages

So the bot never sees “normal” messages from you unless you @mention it. To have the bot receive **every** message in the group (and then OpenClaw decide to reply only to you):

1. Open Telegram and message **@BotFather**.
2. Send **`/setprivacy`**.
3. Select the **first** bot (Agent A) → choose **Disable**.
4. Send **`/setprivacy`** again and select the **second** bot (Agent B) → choose **Disable**.

After this, both bots receive all group messages. OpenClaw still only lets them reply to messages from you (because of `groupAllowFrom`).

## Summary

| Layer        | Setting / action |
|-------------|-------------------|
| OpenClaw    | `requireMention: false`, `groupAllowFrom: ["8455470574"]` (already in config). |
| Telegram    | For each bot: @BotFather → `/setprivacy` → select bot → **Disable**. |

Then restart the gateway once (`./run-gateway.sh`) and send any message in the group; the bot that handles that chat should reply to every message from you.

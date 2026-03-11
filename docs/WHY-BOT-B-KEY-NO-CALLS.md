# Why Bot B's API key has no calls

**Short answer:** Bot B’s Groq key is only used when messages are handled by **Agent B**. That happens only when the message goes to the **second Telegram bot** (the “admin” account). If you only use the first bot in the group, only Agent A runs and only Agent A’s key gets calls.

## How routing works

| Telegram bot | Token (in .env) | accountId | Agent | Groq key used |
|--------------|------------------|-----------|--------|----------------|
| **First bot**  | `TELEGRAM_MAIN_BOT_TOKEN` (8607958856...) | `main`   | **Agent A** (main) | `GROQ_API_KEY` |
| **Second bot** | `TELEGRAM_BOT_TOKEN` (8699190432...)      | `admin`  | **Agent B** (AdminCreateWebsiteBot) | `GROQ_API_KEY_AGENT_B` |

- Messages sent **to the first bot** (or in a chat where that bot is the one that receives the message) → **Agent A** → `GROQ_API_KEY` gets the API calls.
- Messages sent **to the second bot** → **Agent B** → `GROQ_API_KEY_AGENT_B` gets the API calls.

So if only the **first** bot is in the group (or you only ever message that bot), Bot B never runs and **Bot B’s key has zero calls**.

## What to do so Bot B’s key gets calls

1. **Add the second bot to the group**  
   The bot that uses `TELEGRAM_BOT_TOKEN` (8699190432...) must be in the group. Get its username from @BotFather (e.g. `@YourAdminCreateWebsiteBot`) and add it to the group.

2. **Message or mention that bot**  
   In the group, send a message that goes to the **second** bot (e.g. start with its username, or reply to it, or use “Open chat” with that bot so the group chat is linked). Then that message is handled by **Agent B** and `GROQ_API_KEY_AGENT_B` is used.

3. **Check which bot is in the group**  
   If you only see one bot in the group, it’s probably the first one (Agent A). Add the second bot so both are present; then messaging/mentioning the second bot will trigger Agent B and use Bot B’s key.

## Summary

- **Bot B’s API key has no calls** because no messages are being routed to Agent B.
- **Fix:** Add the second Telegram bot (AdminCreateWebsiteBot) to the group and send messages to that bot so Agent B runs and `GROQ_API_KEY_AGENT_B` is used.

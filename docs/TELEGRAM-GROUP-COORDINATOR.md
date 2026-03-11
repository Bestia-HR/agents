# Add AdminCreateWebsiteBot to the Telegram group to coordinate other bots

## What you have

- **One Telegram bot** (your bot token in config) is wired to **AdminCreateWebsiteBot**.
- AdminCreateWebsiteBot can **coordinate the other agent (Main)** via **sessions_send** / **sessions_list** / **sessions_history** (agent-to-agent tools are enabled).

So: your bot in the group **is** AdminCreateWebsiteBot; it coordinates the Main agent (the “other bot”) by sending it tasks and reading its replies.

## Add the bot to the group

1. Open the Telegram group (e.g. **DoximaDigitalFullStackWebsite**).
2. **Add members** → search for your bot by username (e.g. `@YourBotName`).
3. Add the bot to the group.

After that, messages in the group go to AdminCreateWebsiteBot. It will reply and can delegate work to the Main agent using **sessions_send**.

## How coordination works

- **Users** write in the group → **AdminCreateWebsiteBot** (your bot) replies.
- When AdminCreateWebsiteBot decides the **Main** agent should do the work, it uses **sessions_send** to send a task to Main’s session. Main runs the task; AdminCreateWebsiteBot can read the result with **sessions_history** and then answer the user.

So the bot you added to the group is the coordinator; the “other bot” (Main) is the one it commands via the session tools.

## Optional: two visible bots in the same group

If you want **two different bots** in the group (one coordinator, one worker):

1. Create a **second** bot in Telegram with **@BotFather** (e.g. “AdminCreateWebsiteBot” and “MainBot”).
2. In OpenClaw config, add a second Telegram **account** and bind it to the other agent (see [Multi-Agent Routing](https://docs.openclaw.ai/concepts/multi-agent) – Telegram bots per agent).
3. Add **both** bots to the group. Then @mention the coordinator bot for AdminCreateWebsiteBot and the other for Main; AdminCreateWebsiteBot can still use **sessions_send** to command Main’s session.

With one bot (current setup), the single bot in the group is AdminCreateWebsiteBot and already coordinates the other (Main) agent.

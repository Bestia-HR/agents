# Why the bot didn't answer "all bots show me a /status"

## Main reason: use the command, not a sentence

In Telegram, **/status** is a **slash command**. It is only run when the message **is** the command (or starts with it as a command), not when it’s part of a sentence.

| You sent | What the bot sees |
|----------|--------------------|
| `all bots show me a /status` | Normal text. The bot treats it like any other message and may reply with the model (or fail silently). **/status is not run.** |
| `/status` | Slash command. OpenClaw runs the status command and replies with the status card. |

So the bot didn’t “show status” because **/status was never executed** — it was just text inside a sentence.

## What to do

1. **Send the command alone**  
   In the Macbotd group, send exactly:
   ```
   /status
   ```
   (You can type `/status` and send that as the whole message. In Telegram, commands often appear in a list when you type `/`.)

2. **If you want both bots to answer**  
   - You have two bots (Agent A and Agent B). Each only replies when **it** receives the message.
   - Send **/status** once: the bot that “gets” the message (or that you @mention) will reply.
   - To get **both** to show status: mention each bot and send the command to each, for example:
     - `@MainBotName /status`
     - `@AdminCreateWebsiteBotName /status`
   (Use the real Telegram usernames of your two bots.)

3. **Gateway must be running**  
   The bot can only reply if the OpenClaw gateway is running (`./run-gateway.sh`). If it’s stopped, no bot will answer.

4. **If the bot still doesn’t reply**  
   - Check **rate limits**: a 413/429 from Groq can cause no reply. Try a new chat or wait a minute and send **/status** again.
   - Check **logs**: `openclaw logs --follow` to see errors when you send the message.

## Summary

- Send **`/status`** as the whole message (or with an @mention), not “all bots show me a /status”.
- To get both bots to respond, send **/status** to each bot (e.g. by @mentioning each one).
- Ensure the gateway is running and that you’re not hitting API rate limits.

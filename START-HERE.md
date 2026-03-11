# Start here — type your prompt and get a reply

## One-time: let the bots see your messages (Telegram)

By default Telegram bots only see @mentions and replies. So they never see a plain "hi" or your prompt.

**Do this once:**

1. In Telegram, open **@BotFather**.
2. Send: **`/setprivacy`**.
3. Select **your first bot** (Main / Agent A) → choose **Disable**.
4. Send **`/setprivacy`** again → select **your second bot** (AdminCreateWebsiteBot) → **Disable**.

After this, both bots receive all messages in the group. You can type any prompt normally.

---

## Every time: start the gateway

In a terminal:

```bash
cd /Users/user/agent
./run-gateway.sh
```

Leave it running. The script will try to warm the Ollama model so your first message doesn’t time out.

**If Ollama isn’t running**, start it first (in another terminal):

```bash
ollama serve
ollama run llama3.2
```

Then run `./run-gateway.sh`.

---

## Use it

Open your **Macbotd** group in Telegram and type your prompt (e.g. "hi" or "build a small HTML page"). The bot should reply. No @mention needed.

---

## If the bot still doesn’t answer

- See **docs/BOT-NOT-ANSWERING-HI.md** for the full checklist.
- Make sure **privacy is disabled** for both bots (step above).
- Make sure the **gateway** is running (`./run-gateway.sh`).
- If you see "LLM request timed out", run `./warm-ollama.sh` in another terminal and leave it open, then try again.

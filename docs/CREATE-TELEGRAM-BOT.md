# Create a Telegram bot and connect it to OpenClaw

Follow these steps to **create** a new Telegram bot and use it with your agents.

---

## Step 1: Create the bot in Telegram

1. Open **Telegram** (app or web).
2. Search for **@BotFather** (official Telegram bot, has a blue checkmark).
3. Start a chat and send:
   ```
   /newbot
   ```
4. **BotFather** will ask:
   - **Name** – e.g. `AdminCreateWebsite Bot` (display name, can have spaces).
   - **Username** – must end in `bot`, e.g. `AdminCreateWebsiteBot` or `MyGroupCoordinatorBot`. It must be **unique**; if taken, try another (e.g. `YourNameCoordinatorBot`).
5. When it’s done, **BotFather** sends a message with a **token** like:
   ```
   1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
   ```
6. **Copy that token** and keep it secret (don’t share or commit it).

---

## Step 2: Put the token in your project

1. Open **`.env`** in the project root.
2. Set the token (use your real token, not the example):
   ```bash
   TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
   ```
3. Open **`openclaw.json`** and set the same token under Telegram:
   - Go to `channels` → `telegram` → `botToken`.
   - Replace the value with your new token (same as in `.env`).

   Or leave `botToken` in the config and only set `TELEGRAM_BOT_TOKEN` in `.env` if your OpenClaw setup reads the token from env.

---

## Step 3: Run auth and gateway

1. In the project folder, run:
   ```bash
   bash setup-auth.sh
   ```
2. Start the gateway:
   ```bash
   ./run-gateway.sh
   ```
3. In Telegram, open a **DM** with your new bot and send e.g. `Hi`.
4. The bot may reply with a **pairing code**. In a terminal (with the gateway running), run:
   ```bash
   openclaw pairing list telegram
   openclaw pairing approve telegram YOUR_CODE
   ```
   (Use the code from the bot’s message, not the token.)

---

## Step 4: Add the bot to your group

1. Open your Telegram **group** (e.g. DoximaDigitalFullStackWebsite).
2. Tap **Add members** (or group info → Add members).
3. Search for your bot by **username** (e.g. `@AdminCreateWebsiteBot`).
4. Add it to the group.

After that, the bot can receive messages in the group. With your config, **AdminCreateWebsiteBot** handles all Telegram and can coordinate the other agent.

---

## If you already have a token

Your config already has a token (`8607958856:AAF4...`). If the bot **doesn’t respond**:

- Check that the token is correct (copy again from BotFather: open @BotFather → **My Bots** → your bot → **API Token**).
- Make sure the **gateway is running** (`./run-gateway.sh`).
- For groups: ensure your user ID (`8455470574`) is in `allowFrom` / `groupAllowFrom` (already in your config).
- Restart the gateway after changing `.env` or `openclaw.json`.

If you want a **new** bot (e.g. a second bot for “AdminCreateWebsiteBot” only), create it in BotFather as above and then either replace the token (one bot) or add a second Telegram account in OpenClaw (two bots in one group). See `docs/TELEGRAM-GROUP-COORDINATOR.md` for the two-bot option.

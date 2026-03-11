# OpenClaw AI Agent — Ollama only (local) + Internet

This project configures **OpenClaw** agents (Agent A, Agent B) using **local Ollama only**, with **web search and fetch** enabled.

## What you get

- **Agent A (main):** Ollama Llama 3.2 (local) — for general and coding tasks
- **Agent B (AdminCreateWebsiteBot):** Ollama Llama 3.2 (local) — coordinator in Telegram, can delegate to Agent A
- **Internet:** Web search and web fetch enabled
- **Platform:** [OpenClaw](https://openclaw.ai) — personal AI assistant (WhatsApp, Telegram, Slack, Discord, WebChat, etc.)

## Prerequisites

- **Node.js ≥ 22**
- **Ollama** (local) — install from [ollama.ai](https://ollama.ai), run `ollama run llama3.2`, set `OLLAMA_API_KEY=ollama-local` in `.env`, then run `bash setup-auth.sh`
- **Ollama** (optional) — [ollama.ai](https://ollama.ai) for local Llama models
- **Brave Search API key** (optional, for web search) — [brave.com/search/api](https://brave.com/search/api)

### Gateway auth token (for WebChat / API)

The gateway uses a **token you choose** to authorize WebChat and other clients. You don’t get it from a website — pick any secret string (e.g. a long random password).

- **In this project the token is set in:** `openclaw.json` → `gateway.auth.token` (see below). You can instead put it only in `.env` as `OPENCLAW_GATEWAY_TOKEN=...` and remove it from the config so it isn’t committed.
- Or when starting: `openclaw gateway --token your-secret-token`

Use the same token when connecting from WebChat or the CLI. On **localhost only**, some setups may allow connections without a token; for remote or secure use, always set a token.

## Quick setup

### 1. Install OpenClaw

```bash
npm install -g openclaw@latest
```

### 2. Use this project’s config

Copy the config and env example into OpenClaw’s home (or merge with your existing `openclaw.json`):

```bash
# Create OpenClaw config directory if needed
mkdir -p ~/.openclaw

# Copy this project’s config (merge manually if you already have openclaw.json)
cp openclaw.json ~/.openclaw/openclaw.json

# Copy env example and add your keys
cp .env.example .env
# Edit .env and set OLLAMA_API_KEY=ollama-local and optionally BRAVE_API_KEY
```

Load env when running (e.g. in `~/.openclaw/openclaw.json` you can reference env vars, or run):

```bash
export $(cat .env | xargs)
```

### 3. Run onboarding (first time)

```bash
openclaw onboard --install-daemon
```

When prompted, choose **Ollama** or skip and set `OLLAMA_API_KEY=ollama-local` in `.env`. The wizard can also configure web search.

### 4. Run the agent

**Option A — Open WebChat (start gateway + open browser):**

```bash
cd /Users/user/agent
chmod +x open-webchat.sh    # once, if you get "permission denied"
./open-webchat.sh          # or: bash open-webchat.sh
```

**Option B — Scripts (gateway + agent):**

```bash
cd /Users/user/agent
chmod +x run-gateway.sh run-agent.sh open-webchat.sh

# Terminal 1: start gateway (then open http://127.0.0.1:18789 in browser)
./run-gateway.sh

# Terminal 2: send a message to Agent A (main) or Agent B (AdminCreateWebsiteBot)
./run-agent.sh "Hello, say hi in one sentence."
./run-AdminCreateWebsiteBot.sh "Explain REST in one sentence."
```

**Option B — Manual:**

```bash
# Terminal 1: start gateway
openclaw gateway --port 18789 --verbose
```

In another terminal (with `OLLAMA_API_KEY` in env or `.env` loaded):

```bash
export $(grep -v '^#' .env | xargs)   # if using .env
openclaw agent --message "Your question here" --thinking high
```

Or open **WebChat** at http://127.0.0.1:18789 and chat in the browser.

### 5. Connect to Telegram

The agent can chat on **Telegram** (DMs and groups). The agent keeps **web search and fetch** enabled, so it can use the internet in Telegram too.

**Step 1 — Create a bot**

1. Open **Telegram** and search for **@BotFather** (official, blue checkmark).
2. Send **`/newbot`**.
3. Enter a name (e.g. “My AI”) and a username ending in `bot` (e.g. `my_ai_agent_bot`).
4. Copy the **bot token** (e.g. `123456789:ABCdef...`).

**Step 2 — Add token to `.env`**

```bash
# In /Users/user/agent/.env
TELEGRAM_BOT_TOKEN=123456789:ABCdef...
```

**Step 3 — Start the gateway**

```bash
cd /Users/user/agent
bash run-gateway.sh
# or: ./open-webchat.sh
```

**Step 4 — Approve yourself (first time only)**

1. In Telegram, open **your bot** (the one you created with BotFather) and send any message (e.g. “Hi”).
2. The bot will reply with a **pairing code** — a short code like `X7K2M9` or `abc123` (not your bot token). It expires in ~1 hour.
3. In a terminal (gateway must be running, same project and env):

   ```bash
   cd /Users/user/agent
   source .env   # or: export $(grep -v '^#' .env | xargs)
   openclaw pairing list telegram    # see pending codes
   openclaw pairing approve telegram X7K2M9   # use the CODE from the bot's reply, not TELEGRAM_BOT_TOKEN
   ```

   **Important:** Use the short **pairing code** from the bot’s message, not `TELEGRAM_BOT_TOKEN` from `.env`. Using the bot token here causes “No pending pairing request found for code”.

4. Send another message in Telegram; the agent should reply and can use the internet when needed.

**Giving the agent HTML (or other) knowledge:** The agent’s workspace is `workspace/` in this project. It already loads **HTML_KNOWLEDGE.md** (HTML reference) and **AGENTS.md** (instructions to use it for HTML questions). To add more topics, add `.md` files in `workspace/` and reference them in `workspace/AGENTS.md`, then restart the gateway.

**In groups:** Add the bot to a group. By default the bot only replies when **mentioned** (e.g. `@my_ai_agent_bot what's the weather?`).

**Step 5 — Add your Telegram user ID (when the bot asks to “configure auth”)**

The bot may ask you to add your ID in Claw so it knows who is allowed. Put your **numeric Telegram user ID** here:

| Where | What to set |
|-------|-------------|
| **File** | `openclaw.json` |
| **Path** | `channels.telegram.allowFrom` |
| **Value** | `["tg:YOUR_USER_ID"]` — replace `YOUR_USER_ID` with your numeric ID (e.g. `["tg:123456789"]`). You can also use `"123456789"` without the `tg:` prefix. |

**How to find your Telegram user ID**

1. **From OpenClaw logs (recommended):** With the gateway running, run `openclaw logs --follow`, then send a DM to your bot. In the log output, look for `from.id` — that number is your user ID.
2. **From Telegram API:** Run  
   `curl "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates"`  
   then send a message to the bot and run the same command again; look for `"from":{"id":123456789,...}`.
3. **From a bot:** In Telegram, message **@userinfobot** or **@getidsbot**; they reply with your user ID (less private).

After editing `openclaw.json`, restart the gateway. Example in config:

```json
"channels": {
  "telegram": {
    "allowFrom": ["tg:123456789"]
  }
}
```

## Config overview

| Setting | Purpose |
|--------|--------|
| `agents.defaults.model.primary` | Ollama Llama 3.2 (local only) |
| `tools.web.search.enabled` | Lets the agent search the web (Brave) |
| `tools.web.fetch.enabled` | Lets the agent fetch and read URLs |
| `skills.entries.web_search` / `web_fetch` | Enable built-in web skills |

## Using the agent for internet tasks

Once the gateway is running and web tools are enabled:

- **Search:** e.g. “Search the web for …” or “What’s the weather in Paris?”
- **Fetch:** e.g. “Open this URL and summarize the page: https://…”
- **Research:** e.g. “Find recent articles about X and summarize the main points.”

The agents use local Ollama only and call web search / web fetch when needed.

## Optional: custom skills

To add custom skills (e.g. extra APIs), put them under `skills/` and set in config:

```json
"skills": {
  "load": {
    "extraDirs": ["./skills"]
  }
}
```

Then reference this project path as an extra workspace or copy `openclaw.json` into `~/.openclaw/` and run OpenClaw from there.

## Links

- [OpenClaw docs](https://docs.openclaw.ai)
- [Getting started](https://docs.openclaw.ai/start/getting-started)
- [Ollama](https://docs.openclaw.ai/providers/ollama) · [Models](https://docs.openclaw.ai/concepts/models)
- [Web tools](https://docs.openclaw.ai/tools) (search, fetch)

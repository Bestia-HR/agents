# Export agent to Windows and collaborate with existing (Mac) agent

This guide gets the same agent running on Windows and configures **collaboration** with the agent already running on your Mac (e.g. both in one Telegram group).

---

## Part 1: What to copy to Windows

**Option A — Use the ready-made zip**

In the project folder there is **`agent-export.zip`** with everything you need (no secrets, no state):

- Unzip it on your Mac, then copy the unzipped folder to Windows (USB, cloud, etc.), **or**
- Copy `agent-export.zip` to Windows and unzip it there (e.g. right‑click → Extract All).

See **`FILES-TO-COPY.txt`** inside the zip for a short list of what’s included.

**Option B — Copy files manually**

Copy these from the agent project to the Windows PC:

- `openclaw.json`
- `workspace/` (entire folder: AGENTS.md, SOUL.md, all *_KNOWLEDGE.md, etc.)
- `.env.example` (do **not** copy `.env` with real keys over insecure channels)
- `run-gateway.ps1` (use it to start the gateway on Windows)
- Optional: `WINDOWS-EXPORT.md`, `FREE-SEARCH-ALTERNATIVES.md`, `EXPORT-AND-MULTI-DEVICE.md`

Transfer via: USB drive, cloud (OneDrive, Google Drive), or your own zip.

**Do not copy** `.openclaw-state/` from Mac if you want the Windows agent to have its own sessions and a **separate Telegram bot** for collaboration (recommended). If you copy it, the Windows agent would share the same bot and state as the Mac.

---

## Part 2: Install OpenClaw on Windows

1. **Install Node.js 22+**  
   - Download from [nodejs.org](https://nodejs.org/) (LTS) and run the installer.  
   - Or: `winget install OpenJS.NodeJS.LTS`  
   - Check: `node --version`

2. **Install OpenClaw globally**  
   In PowerShell (Run as Administrator if needed):
   ```powershell
   npm install -g openclaw@latest
   ```
   Verify: `openclaw --version`

3. **If `openclaw` is not found**  
   Add npm’s global bin to PATH. Run:
   ```powershell
   npm config get prefix
   ```
   Add that folder (e.g. `C:\Users\You\AppData\Roaming\npm`) to your user **Path** in Environment Variables.

---

## Part 3: Configure the agent on Windows

1. **Put the copied folder** where you want, e.g. `C:\Users\YourName\agent`.

2. **Fix the workspace path in `openclaw.json`**  
   Your Mac path is `/Users/user/agent/workspace`. On Windows it must be a Windows path.  
   Open `openclaw.json` and change `agents.defaults.workspace` to your Windows path. Use **forward slashes** or **escaped backslashes** in JSON:
   - Example (forward slashes): `"workspace": "C:/Users/YourName/agent/workspace"`
   - Example (backslashes in JSON): `"workspace": "C:\\Users\\YourName\\agent\\workspace"`  
   Replace `YourName` and path with your actual folder.

3. **Create `.env` on Windows**  
   Copy `.env.example` to `.env` in the same folder and fill in:
   - `NVIDIA_API_KEY` — same as Mac (or your own key)
   - `GEMINI_API_KEY` — for web search (same as Mac or your own)
   - `TELEGRAM_BOT_TOKEN` — **use a different bot for Windows** (see Part 4)
   - `OPENCLAW_GATEWAY_TOKEN` — choose a **new** secret for the Windows gateway (do not reuse the Mac token)

4. **Use project-local state on Windows (optional but recommended)**  
   So the Windows agent keeps its own state in the project folder, set the state dir when running (the script below does this):
   - State dir: `C:\Users\YourName\agent\.openclaw-state`  
   Create that folder if it doesn’t exist. The PowerShell script will set `OPENCLAW_STATE_DIR` to the project’s `.openclaw-state` and load `.env`.

---

## Part 4: Collaboration — two agents in one Telegram group

To have the **Mac agent** and the **Windows agent** collaborate (both see the same chat and can respond):

1. **Mac (current setup)**  
   - Keeps using your existing Telegram bot (Bot A).  
   - No change needed.

2. **Create a second Telegram bot for Windows (Bot B)**  
   - In Telegram, open [@BotFather](https://t.me/BotFather).  
   - Send `/newbot`, choose a name (e.g. “My Agent Windows”), choose a username (e.g. `MyAgentWindows_bot`).  
   - Copy the **token** BotFather gives you.

3. **Configure the Windows agent to use Bot B**  
   - In the Windows project folder, in `.env`, set:
     ```
     TELEGRAM_BOT_TOKEN=<paste Bot B token here>
     ```
   - In `openclaw.json`, under `channels.telegram`, set `botToken` to the same Bot B token (or leave it out and rely on `.env`).

4. **Add both bots to the same Telegram group**  
   - Add Bot A (Mac) to the group if not already.  
   - Add Bot B (Windows) to the **same** group.  
   - In `openclaw.json` on **both** Mac and Windows, ensure the group is allowed (e.g. `groupPolicy: "allowlist"` and the group ID in allowlist, or temporarily `groupPolicy: "open"` for testing).  
   - Ensure `allowFrom` on Windows includes your Telegram user ID (you can get it from Bot A or a “user info” bot).

5. **How they collaborate**  
   - You post **one task** in the group (e.g. “Best way to structure a React app?”).  
   - Mention **@BotA** — the Mac agent replies.  
   - Mention **@BotB** — the Windows agent replies.  
   - You can say “@BotB, do you agree with the first answer?” so the second agent responds to the first.  
   - Both agents see the same group messages (within history limits), so they can effectively “collaborate” with you directing who speaks.

---

## Part 5: Run the agent on Windows

1. Open PowerShell and go to the agent folder:
   ```powershell
   cd C:\Users\YourName\agent
   ```

2. Run the gateway (uses `.env` and project state dir):
   ```powershell
   .\run-gateway.ps1
   ```
   If you get an execution policy error, run once:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
   Then run `.\run-gateway.ps1` again.

3. **First-time setup**  
   Run doctor so OpenClaw repairs/migrates state:
   ```powershell
   $env:OPENCLAW_STATE_DIR = "$PWD\.openclaw-state"; openclaw doctor
   ```
   Then start the gateway with `.\run-gateway.ps1`.

4. **Pair Telegram (Bot B) on Windows**  
   In Telegram, open a DM with Bot B, send a message; the gateway will show a pairing code. Approve it (e.g. in WebChat or as configured) so the Windows agent can respond in DMs and in the shared group.

---

## Summary

| Step | Action |
|------|--------|
| Copy to Windows | Whole project folder (openclaw.json, workspace/, .env.example, run-gateway.ps1). Do not copy .env. |
| Install | Node.js 22+ → `npm install -g openclaw@latest` |
| Paths | Set `agents.defaults.workspace` in openclaw.json to your Windows path (e.g. `C:/Users/You/agent/workspace`). |
| .env | Create from .env.example; set NVIDIA_API_KEY, GEMINI_API_KEY, **new** TELEGRAM_BOT_TOKEN (Bot B), **new** OPENCLAW_GATEWAY_TOKEN. |
| Collaborate | Create Bot B with @BotFather; add Bot A (Mac) and Bot B (Windows) to the same Telegram group; @mention each bot to get each agent to reply. |
| Run | `.\run-gateway.ps1` from the agent folder (after `openclaw doctor` once with OPENCLAW_STATE_DIR set). |

After this, the Windows agent runs next to your Mac agent and both can collaborate in the same Telegram group.

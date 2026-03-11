# Export agent to another device & two agents debating on one task

## Part 1: Export this agent to another device

Your setup uses a **project-local** config: `openclaw.json` and `workspace/` in this folder, and state in `.openclaw-state/` (when you run with `OPENCLAW_STATE_DIR` set to this project).

### What to copy to the new device

Copy the whole **agent project folder**, including:

- `openclaw.json`
- `workspace/` (all knowledge files, AGENTS.md, SOUL.md, etc.)
- `.openclaw-state/` (if you use it — contains auth, sessions, channel state)
- `.env.example` (never copy `.env` with real keys over insecure channels)
- Scripts you use: `open-webchat.sh`, `setup-auth.sh`, etc.

Ways to transfer: USB drive, `rsync`, `scp`, or zip the folder and copy.

### On the new device

1. **Install OpenClaw** (and Node if needed): see [OpenClaw Install](https://docs.openclaw.ai/install).

2. **Put the copied folder** where you want (e.g. `~/agent`).

3. **Set environment variables**  
   Create a `.env` from `.env.example` and fill in keys on the new machine:
   - `NVIDIA_API_KEY` (and optionally `GEMINI_API_KEY` or `BRAVE_API_KEY` for search)
   - `TELEGRAM_BOT_TOKEN` (if you want the same bot; or create a new bot for this device)
   - `OPENCLAW_GATEWAY_TOKEN` (choose a new secret for this gateway)

4. **Fix paths in `openclaw.json`**  
   Your `workspace` is set to an absolute path (`/Users/user/agent/workspace`). On the new device either:
   - Edit `openclaw.json` and set `agents.defaults.workspace` to the new path (e.g. `"/home/you/agent/workspace"`), or
   - Use a path relative to where you run OpenClaw if your version supports it.

5. **Use the same state dir (optional)**  
   If you want this device to keep the same sessions/auth as the old one, run with the same state dir:
   ```bash
   export OPENCLAW_STATE_DIR=/path/to/agent/.openclaw-state
   openclaw doctor
   openclaw gateway start
   ```
   If you skip this, OpenClaw may use `~/.openclaw/` and you’ll get a fresh state (new sessions, need to re-pair Telegram, etc.).

6. **Run doctor and start**
   ```bash
   openclaw doctor
   openclaw gateway start
   ```

### Alternative: OpenClaw built-in export (when gateway is running)

If your OpenClaw dashboard has an **Export** button, it creates a `.tar.gz` with config + workspace + state. You can move that file to the other device, extract it into the state directory used there, then run `openclaw doctor` and start the gateway. Credentials are in the archive — treat it as secret and transfer securely.

---

## Part 2: Two agents on two devices “debating” about one task

OpenClaw does not have a built-in “debate mode” where Agent A on device 1 and Agent B on device 2 automatically exchange turns on one topic. You can get a similar effect in these ways:

### Option A: Shared channel (e.g. one Telegram group) — simplest

- **Device 1:** Run this agent connected to Telegram (same bot or two different bots).
- **Device 2:** Run a second OpenClaw agent (exported copy or different config) connected to the **same Telegram group** (or same bot in group).

You post **one task** in the group (e.g. “What’s the best way to structure a React app?”).  
Both agents can reply. You (or someone) can then say: “Agent 2, do you agree with the first answer?” so they effectively “debate” in the same thread, with you guiding who speaks next.

- **Same bot:** Only one bot can be in a group; so you’d run one gateway per device and only one of them can use that group with that bot, or you use one gateway and multiple agents on the same gateway (same device).
- **Two bots:** Add two different bots to one group. On device 1 run gateway + agent with Bot A; on device 2 run gateway + agent with Bot B. Both bots see the same messages; you @mention each bot when you want that agent to answer or “debate.”

So for two agents on **two devices** to both be in the same group, you need **two Telegram bots** (e.g. Bot A on device 1, Bot B on device 2), both in the same group. You ask one question; each bot can answer; you ask the other to respond to the first, etc.

### Option B: One agent calls the other (custom tool / API)

- On **device 2** you run the second agent and expose it via an HTTP API or MCP server that accepts a “task” and returns “response.”
- On **device 1** you give the first agent a **custom skill or MCP tool** like “ask_remote_agent(task)” that:
  - Sends the task to device 2’s API,
  - Waits for the reply,
  - Returns that reply to the first agent.

Then the first agent can “ask” the second agent’s opinion and use it in its own answer (e.g. “My view is X; the other agent says Y; here’s a synthesis”). That’s a form of debate orchestrated by the first agent. Implementing this requires writing a small HTTP/MCP server around the second agent and a skill or MCP client on the first.

### Option C: Subagents on one device (same machine, not two devices)

OpenClaw **subagents** run on the **same** OpenClaw instance (same device). One agent can spawn subagents with different instructions (e.g. “argue for approach A” vs “argue for approach B”) and then combine their answers. That gives a “debate” on one task but on a single device, not across two machines.

---

## Summary

| Goal | What to do |
|------|------------|
| **Export to another device** | Copy this project folder (config, workspace, .openclaw-state, scripts), install OpenClaw on the new device, set `.env`, fix `workspace` path, run `openclaw doctor` and start the gateway. |
| **Two agents on two devices debating** | Use one Telegram group with **two bots** (one agent per device, one bot per agent); you post one task and prompt each bot to reply or respond to the other. For automatic back-and-forth, add a custom API on the second device and a “ask remote agent” tool on the first. |

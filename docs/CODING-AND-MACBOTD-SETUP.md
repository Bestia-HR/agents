# Coding optimization and Macbotd group setup

Both bots on this device are tuned for **coding** and are set up to **answer your questions in the Telegram group Macbotd**.

## What was optimized

### 1. Model (openclaw.json)

- **Temperature:** 0.3 → **0.25** (more deterministic, better for code).
- **Thinking:** high → **medium** (faster replies, fewer tokens, still good for coding).
- **Macbotd group:** Group ID **-5049131940** is explicitly allowed; **requireMention: false** so bots reply without @mention.

### 2. Agent A (main) – workspace/AGENTS.md

- Instructed to answer in **Telegram group Macbotd** and to prioritize coding (read/write, knowledge files).
- Coding section clarified: use knowledge files (HTML, JS, React, etc.), answer in the thread, provide runnable code when asked.

### 3. Agent B (AdminCreateWebsiteBot) – workspace-AdminCreateWebsiteBot/AGENTS.md

- Instructed to answer in **Macbotd**; backend questions answered directly, frontend/full-page builds delegated to Agent A via **sessions_send**, then report back.
- Coding section aligned with Macbotd: answer in thread, backend yourself, frontend via delegation.

### 4. Telegram config

- **groups."-5049131940"**: explicit entry for Macbotd with **requireMention: false**.
- **groupPolicy: "open"**, **allowFrom** / **groupAllowFrom** include your user ID (8455470574) so your messages are accepted.

## How to use

1. **Start the gateway** (if not already running):  
   `./run-gateway.sh`

2. **Ask in Macbotd:** Write your coding or general question in the group. Either bot can reply (depending on which bot receives the message). No need to @mention unless you want a specific bot.

3. **For code or a full page:** Agent A can generate code and use the workspace; Agent B can answer backend or delegate to Agent A and paste the result.

## Summary

| Item | Setting |
|------|--------|
| Coding temperature | 0.25 (Groq) |
| Thinking | medium |
| Macbotd group | -5049131940, requireMention: false |
| Agent A | Answers in Macbotd; uses knowledge files + read/write for code |
| Agent B | Answers in Macbotd; backend direct, frontend via delegation to Agent A |

All bots on this device are optimized for coding and configured to work in group Macbotd and answer your questions there.

# Why 4 sessions in Macbotd (2 bots + you)

You have **2 bots** and **1 user** (you) in Macbotd, but OpenClaw shows **4 sessions** linked to that group. Here’s why.

## Sessions are per “conversation type,” not per person

OpenClaw creates **one session per (agent, channel, context)**. For one Telegram group you get **two session types** per bot:

| Session type | What it is | Count in Macbotd |
|--------------|------------|-------------------|
| **Group chat** | Normal messages in the group → bot replies here | 1 per bot → **2** (Agent A + Agent B) |
| **Slash commands** | When you send `/status`, `/usage`, etc. in the group | 1 per bot → **2** (one per bot) |

So: **2 bots × 2 session types = 4 sessions** for Macbotd.

- **Session 1:** Agent A – group chat in Macbotd (`agent:main:telegram:group:-5049131940`)
- **Session 2:** Agent A – slash commands in Macbotd (`telegram:slash:8455470574` with account main)
- **Session 3:** Agent B – group chat in Macbotd (`agent:admincreatewebsitebot:telegram:group:-5049131940`)
- **Session 4:** Agent B – slash commands in Macbotd (`telegram:slash:8455470574` with account admin)

So the “4 sessions” are **2 conversation threads (group) + 2 slash-command threads**, not “4 people” or “4 bots.”

## Summary

| You have | OpenClaw sessions for Macbotd |
|----------|-------------------------------|
| 2 bots + 1 you | 4 sessions (2 group + 2 slash, one pair per bot) |

This is normal. You don’t need to “fix” it; it’s how OpenClaw separates normal chat from slash commands for each bot.

# Do the bots collaborate when they are in one Telegram group?

**Yes.** When both bots (Coder and Researcher) are in the **same** Telegram group, they can work together. Here’s how.

---

## 1. Two bots, one group

You have:

- **Bot 1** (Coder) – one Telegram bot token, bound to agent **main**
- **Bot 2** (Researcher) – another token, bound to agent **AdminCreateWebsiteBot**

When you **add both bots** to the same group:

- Messages **to Bot 1** (e.g. @MainBot) → handled by **Coder**
- Messages **to Bot 2** (e.g. @AdminBot) → handled by **Researcher**

So in one group you have two bots; each message is handled by the bot (and thus the agent) you message or mention.

---

## 2. How they collaborate

**Agent-to-agent tools** are enabled: Researcher can talk to Coder’s session.

- **Researcher** (coordinator) can use:
  - **sessions_list** – find Coder’s session (e.g. the group chat session)
  - **sessions_send** – send a task or question to Coder
  - **sessions_history** – read Coder’s reply

So in one group:

1. **User** writes in the group (e.g. to Bot 2): “Build a small API for login.”
2. **Researcher** receives the message. It can:
   - Answer itself, or
   - Use **sessions_send** to send the same task to **Coder**.
3. **Coder** does the work (e.g. writes the API code) and replies in its session.
4. **Researcher** uses **sessions_history** to read that reply, then **replies in the group** to the user (e.g. with the code or a summary).

So they **collaborate**: Researcher coordinates, Coder executes when Researcher delegates. Both are in the same group; the user talks to one bot, and the other bot can do the work “in the background” via sessions.

---

## 3. Summary

| In one Telegram group | What happens |
|------------------------|--------------|
| Both bots added        | Yes – add both bots as members. |
| Who handles the message? | The bot you message or @mention (Bot 1 → Coder, Bot 2 → Researcher). |
| Do they collaborate?   | Yes – Researcher can send tasks to Coder with **sessions_send** and use **sessions_history** to get the result, then reply to the user in the group. |
| User sees              | One reply in the group (from the bot they wrote to); that bot may have used the other agent to generate the answer. |

So **yes, the bots collaborate when they are in one group**: Researcher can delegate to Coder and combine the result into a single reply to the user.

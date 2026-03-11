# Merged results in Macbotd

You can get **one merged message** in the group that combines both bots’ results (e.g. website code from Agent A and Agent B).

## How it works

- **Agent B** (AdminCreateWebsiteBot) is the coordinator. When you ask for a **merged** or **combined** result, it:
  1. Sends the same task to **Agent A** (Main) via **sessions_send**
  2. Reads Agent A’s reply with **sessions_history**
  3. Merges both results and posts **one** message in the group (e.g. “Agent A: …” + “Agent B: …” or a single combined version)

So you see a single merged reply in Macbotd instead of two separate ones.

## What to write in the group

Send a message like one of these (to the group or by @mentioning the coordinator bot):

- **“Build a simple one-page website with HTML/CSS and merge both bots’ results into one message in the group.”**
- **“Task: create a landing page (header, intro, contact). Use sessions_send so Main does it too, then merge your answer and Main’s and post one combined result here.”**
- **“I want a merged result from both bots: build a minimal website and show me one combined reply here.”**

Agent B will delegate to Main, get Main’s reply, then post one merged message.

## If you use the script

The script `send-website-build-test-macbotd.sh` sends the same prompt to **both** agents separately; each posts its own reply. That gives you two messages.

To get a **merged** result from the group instead:

1. Don’t run the script for that task, **or**
2. In the group, send the merged-result prompt above (so only Agent B answers, and it merges and posts one message).

## Summary

| Goal | What to do |
|------|------------|
| Two separate replies (Agent A + Agent B) | Use the script or ask each bot separately. |
| One merged reply in the group | Ask in the group for “merged” or “combined” results; Agent B will coordinate and post one message. |

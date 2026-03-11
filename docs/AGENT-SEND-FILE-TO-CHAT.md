# Agent sending files to the Telegram chat

The bots can send files (code, images, documents) to the Macbotd Telegram chat.

## Config changes

1. **Telegram actions:** `channels.telegram.actions.sendMessage` is set to **true** so the agent is allowed to use the message/send action (including with attachments).

2. **Message tool:** OpenClaw 2026.3.2 does not support `tools.message.mediaLocalRoots`. The agent sends files by writing to the workspace, copying to **/tmp** (or another allowed path), then using the message tool or `MEDIA:/tmp/filename`. Allowed paths include `/tmp` and the OpenClaw state directory.

3. **Channel media size:** `channels.telegram.mediaMaxMb` is 200 (and agents.defaults.mediaMaxMb is 1024), so larger files are allowed.

## How the agent sends files

- The agent uses the **message** tool to send a message with an attachment, or includes **MEDIA:<path>** in its reply so the gateway attaches the file.
- Files must be under an allowed path (workspace, `mediaLocalRoots`, or system temp). The agent instructions tell it to write the file to the workspace and then send it.

## If files don’t send

- Restart the gateway after config changes: `./run-gateway.sh`.
- If you see a config error about `mediaLocalRoots`, run `openclaw doctor --fix`; the agent can still send files from `/tmp` or by staging to an allowed dir.
- Ask the user to request explicitly: e.g. “send me the file” or “attach the HTML file to the chat.”

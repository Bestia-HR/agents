# "Fetch failed" still appears — what to try

If you still see "fetch failed" after disabling `tools.web.fetch` and `skills.entries.web_fetch`:

## 1. Explicit deny (already added)

In `openclaw.json`, **tools.deny** now includes **web_fetch** so the tool is blocked even if the skill is loaded:

```json
"tools": {
  "deny": ["web_fetch"],
  "web": { ... }
}
```

Restart the gateway after any config change: `./run-gateway.sh` (stop with Ctrl+C first if it's running).

## 2. Check which "fetch" is failing

- **"Web Fetch: ... failed"** or **"web_fetch failed"** in the reply → the agent tried to use web_fetch. With deny + disabled, it should not be available. Ensure you restarted the gateway and are using this project's config (`OPENCLAW_CONFIG_PATH` and `OPENCLAW_STATE_DIR` point to this folder when you run the gateway).
- **"Fetch failed"** in the **dashboard or WebChat UI** (no reply from the bot) → often the **browser failing to reach the gateway** (wrong URL, token, or gateway not running). Not the web_fetch tool. Fix: open the correct URL with token, or restart the gateway.
- **Error in terminal** when running a script → might be gateway connection or session lock; see `docs/GATEWAY-TIMEOUT-AND-SESSION-LOCK.md`.

## 3. Disable web_search too (test only)

To see if the error is from **web_search** (Gemini) instead of web_fetch, temporarily disable search:

```json
"tools": {
  "deny": ["web_fetch"],
  "web": {
    "search": { "enabled": false },
    "fetch": { "enabled": false }
  }
},
"skills": {
  "entries": {
    "web_search": { "enabled": false },
    "web_fetch": { "enabled": false }
  }
}
```

Restart the gateway and run your "no internet" prompt again. If the error **stops**, the failure was from a web tool (search or fetch). You can then re-enable `web_search` if you need it for other tasks.

## 4. Ensure this config is used

When you start the gateway, it must load **this** `openclaw.json`:

```bash
cd /Users/user/agent
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
./run-gateway.sh
```

Or run `./run-gateway.sh` from the project folder (the script sets these). If the gateway was started from another directory or without these env vars, it may be using a different config where web_fetch is still enabled.

# Gateway timeout and "session file locked"

If when running `./send-website-build-test-macbotd.sh` (or any `openclaw agent ... --deliver`) you see:

- **`gateway timeout after 630000ms`** then **`falling back to embedded`**
- **`session file locked (timeout 10000ms): pid=...`** / **FailoverError: session file locked**

here’s what’s going on and how to fix it.

## What’s happening

1. The CLI sends the task to the **gateway** (e.g. `ws://127.0.0.1:18789`). It waits for the gateway to run the agent and return the reply (or deliver it to Telegram).
2. If the gateway doesn’t respond in time (e.g. default ~630 s), the CLI gives up and **falls back to embedded** (runs the agent locally in the same process).
3. In embedded mode the CLI tries to use the **same session file** the gateway is already using for that Telegram group. The gateway holds the lock on that file, so you get **session file locked** and the run fails.

So: the timeout means the gateway either wasn’t running, or the run was too slow; the lock error is a consequence of falling back to embedded while the gateway still has the session.

## What to do

### 1. Use the gateway (recommended)

- **Start the gateway first** and keep it running in another terminal:
  ```bash
  ./run-gateway.sh
  ```
- Run the script only when the gateway is up. The script now checks that the gateway is reachable and exits with a clear error if not.
- Give the gateway enough time: the script uses a longer `--timeout` (e.g. 900 s). For very long tasks you can set:
  ```bash
  OPENCLAW_AGENT_TIMEOUT=1200 ./send-website-build-test-macbotd.sh
  ```

### 2. Avoid running the same session from two places

- Don’t run `openclaw agent ... --channel telegram --to -5049131940` (or another script that uses the same group/session) at the same time as the gateway is handling that group (e.g. someone chatting in Macbotd). Either use the gateway for Telegram, or run one CLI agent run at a time and wait for it to finish.

### 3. If you see "session file locked"

- Usually the **gateway** (or another openclaw process) holds the lock. Options:
  - **Use the gateway:** Start `./run-gateway.sh` and run the script again so the task goes to the gateway instead of falling back to embedded.
  - **Stop gateway, then run script (recommended for send scripts):** Use the safe wrapper so the script runs in embedded mode without conflict:
    ```bash
    ./run-portfolio-prompt-macbotd-safe.sh
    ```
    This stops the gateway, runs the portfolio prompt (or use `RUN_WITHOUT_GATEWAY=1 ./send-portfolio-prompt-macbotd.sh`), then you start the gateway again. Same idea for `send-website-build-test-macbotd.sh`: stop gateway, then `RUN_WITHOUT_GATEWAY=1 ./send-website-build-test-macbotd.sh`.
  - **Stale lock:** If the process that held the lock has exited (e.g. gateway crashed) but the lock file remains, you can remove it (only if you’re sure no openclaw process is using that session):
    ```bash
    rm -f /Users/user/agent/.openclaw-state/agents/main/sessions/*.jsonl.lock
    rm -f /Users/user/agent/.openclaw-state/agents/AdminCreateWebsiteBot/sessions/*.jsonl.lock
    ```
    Then start the gateway again or run the script again.

## Summary

| Symptom | Cause | Fix |
|--------|--------|-----|
| Gateway timeout then fallback to embedded | Gateway not running or task took > timeout | Start `./run-gateway.sh`; use script’s gateway check; increase `OPENCLAW_AGENT_TIMEOUT` if needed |
| Session file locked (pid=…) | Gateway or another process holds the session | Use gateway for Telegram; don’t run CLI and gateway on same session at once; or remove stale lock if process is gone |

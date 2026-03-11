# GatewayRequestError — increase timeouts

**GatewayRequestError** usually means the **client** (e.g. the OpenClaw CLI or a script) gave up waiting for the gateway before the agent finished. The gateway or agent run is still allowed to take a long time; the limit is often the **request timeout** of the caller.

## What we changed

1. **Scripts that call the gateway** now use a longer default when calling `openclaw agent`:
   - **OPENCLAW_AGENT_TIMEOUT** default is **7200** (2 hours) in:
     - `send-portfolio-prompt-macbotd.sh`
     - `send-website-build-test-macbotd.sh`
     - `send-merged-result-prompt-macbotd.sh`
   - So the CLI waits up to 2 hours for the gateway to respond before throwing GatewayRequestError.

2. **Agent run timeout** in config is already very high:
   - **agents.defaults.timeoutSeconds: 315360000** (10 years) in `openclaw.json` — the gateway will let an agent run that long.

## If you still see GatewayRequestError

- **When running a script:** Increase the timeout before running, e.g.:
  ```bash
  OPENCLAW_AGENT_TIMEOUT=86400 ./send-portfolio-prompt-macbotd.sh
  ```
  (86400 = 24 hours.)

- **When using Telegram:** The Telegram connector uses the gateway; the limit is the agent run (timeoutSeconds). If the bot is slow, keep the model warm (`./warm-ollama.sh`) and consider a smaller maxTokens so each reply finishes sooner.

- **When using WebChat or another HTTP client:** If that client has its own timeout (e.g. 60 s), increase it in the client or proxy so it doesn’t close the connection before the gateway responds.

## Summary

| Cause | Fix |
|-------|-----|
| Script/CLI times out waiting for gateway | Use higher `OPENCLAW_AGENT_TIMEOUT` (default in send-* scripts is now 7200). |
| Agent run timeout | Already high (timeoutSeconds in openclaw.json). |
| Client (browser, proxy) timeout | Increase timeout in that client. |

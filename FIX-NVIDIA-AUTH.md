# Step-by-step: Fix "No API key found for provider nvidia"

Follow these steps **in order**. After each step, try sending a message to the agent again (Telegram or WebChat).

---

## Step 1: Fix the config (already done)

The NVIDIA provider must use `"api": "openai-completions"`, not your API key. Your `openclaw.json` has been corrected.

- **File:** `openclaw.json`
- **Path:** `models.providers.nvidia.api`
- **Must be:** `"openai-completions"` (not the key)

---

## Step 2: Ensure the auth store has your key

Run this **from the project folder** so the key from `.env` is written into the agent auth store:

```bash
cd /Users/user/agent
source .env
bash setup-auth.sh
```

You should see: `Wrote NVIDIA API key to .openclaw-state/agents/main/agent/auth-profiles.json`

Check the file exists:

```bash
cat /Users/user/agent/.openclaw-state/agents/main/agent/auth-profiles.json
```

It should contain a `nvidia:default` profile with your key.

---

## Step 3: Always start the gateway from the project folder with the run script

The gateway must use **this project’s** state directory and config. Start it **only** like this:

```bash
cd /Users/user/agent
bash run-gateway.sh
```

Or (gateway + open browser):

```bash
cd /Users/user/agent
bash open-webchat.sh
```

Do **not** start the gateway with a bare `openclaw gateway` from another directory or without the script — then OpenClaw may use `~/.openclaw` and ignore this project’s auth store.

---

## Step 4: Restart the gateway after any change

After editing config or auth:

1. Stop the gateway (Ctrl+C in the terminal where it’s running).
2. Start it again with one of the commands in Step 3.

---

## Step 5: If it still fails — config env fallback

Your `openclaw.json` has an `env` block with `NVIDIA_API_KEY` so the agent can get the key from the config as well. If you rotate the key, update:

- `.env` → `NVIDIA_API_KEY=...`
- `openclaw.json` → `env.NVIDIA_API_KEY` (same value)

Then run `bash setup-auth.sh` again and restart the gateway.

---

## Quick checklist

- [ ] `openclaw.json` → `models.providers.nvidia.api` is `"openai-completions"`
- [ ] `openclaw.json` → `env.NVIDIA_API_KEY` is your key (or remove and rely on auth store)
- [ ] Ran `bash setup-auth.sh` from `/Users/user/agent`
- [ ] `.openclaw-state/agents/main/agent/auth-profiles.json` exists and has `nvidia:default`
- [ ] Gateway started with `bash run-gateway.sh` or `bash open-webchat.sh` from `/Users/user/agent`
- [ ] Gateway restarted after any change

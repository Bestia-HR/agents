#!/usr/bin/env bash
# Run the portfolio prompt without "session file locked" by stopping the gateway first,
# running the agent in embedded mode, then reminding you to start the gateway again.
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

echo "1. Stopping gateway so this run can use the session (avoids 'session file locked')..."
openclaw gateway stop 2>/dev/null || true
lsof -ti :18789 | xargs kill -9 2>/dev/null || true
sleep 2

echo "2. Removing any stale session locks..."
rm -f .openclaw-state/agents/main/sessions/*.jsonl.lock 2>/dev/null || true
rm -f .openclaw-state/agents/AdminCreateWebsiteBot/sessions/*.jsonl.lock 2>/dev/null || true

echo "3. Sending portfolio prompt (embedded mode; reply will be posted to Macbotd)..."
RUN_WITHOUT_GATEWAY=1 ./send-portfolio-prompt-macbotd.sh

echo ""
echo "4. Start the gateway again when you want normal Telegram bot usage: ./run-gateway.sh"

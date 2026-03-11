#!/usr/bin/env bash
# Send "Hi" to the Telegram group Macbotd from both bots (Agent A and Agent B).
# Usage: ./send-hi-macbotd.sh
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

GROUP_ID="-5049131940"   # Macbotd

echo "Sending 'Hi' from Agent A (main bot)..."
openclaw message send --channel telegram --target "$GROUP_ID" --message "Hi" --account main 2>/dev/null | grep -E "✅|Error" || true

echo "Sending 'Hi' from Agent B (admin bot)..."
openclaw message send --channel telegram --target "$GROUP_ID" --message "Hi" --account admin 2>/dev/null | grep -E "✅|Error" || true

echo "Done. Check the Macbotd group in Telegram."

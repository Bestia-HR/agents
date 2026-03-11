#!/usr/bin/env bash
# Send the "merged result" prompt to Macbotd via console. Agent B will coordinate with Main and post one merged reply in the group.
# Run with gateway already running: ./send-merged-result-prompt-macbotd.sh
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

GATEWAY_URL="${OPENCLAW_GATEWAY_URL:-http://127.0.0.1:18789}"
if ! curl -s -o /dev/null --connect-timeout 5 "$GATEWAY_URL" 2>/dev/null; then
  echo "Error: Gateway not reachable at $GATEWAY_URL"
  echo "Start it first: ./run-gateway.sh"
  exit 1
fi

AGENT_TIMEOUT="${OPENCLAW_AGENT_TIMEOUT:-7200}"
GROUP_ID="-5049131940"

# Prompt so Agent B merges both bots' results and posts one message in the group
MSG="Build a simple one-page website with HTML and CSS (header, intro paragraph, contact section). Use sessions_send so Main does it too, then merge your answer and Main's and post one combined result here in the group."

echo "Sending merged-result prompt to Macbotd (Agent B will coordinate and post one reply)..."
openclaw agent --agent AdminCreateWebsiteBot --channel telegram --to "$GROUP_ID" --message "$MSG" --deliver --thinking off --timeout "$AGENT_TIMEOUT"

echo ""
echo "Done. Check the Macbotd group for the single merged reply."

#!/usr/bin/env bash
# Send a website-building test prompt to the Macbotd group so the bots reply there.
# Run with gateway already running: ./send-website-build-test-macbotd.sh
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

# Fail fast if gateway is not reachable (avoids timeout then "session file locked" fallback)
GATEWAY_URL="${OPENCLAW_GATEWAY_URL:-http://127.0.0.1:18789}"
if ! curl -s -o /dev/null --connect-timeout 5 "$GATEWAY_URL" 2>/dev/null; then
  echo "Error: Gateway not reachable at $GATEWAY_URL"
  echo "Start it first: ./run-gateway.sh"
  exit 1
fi

# Longer timeout so gateway has time to run Ollama (full page + code can take several minutes)
AGENT_TIMEOUT="${OPENCLAW_AGENT_TIMEOUT:-7200}"

# Prompt: self-contained so agent does not need web_fetch (avoids fetch failures). Just generate code.
MSG="Task: Build a simple one-page website. Use only HTML and CSS. Include a header, a short intro paragraph, and a contact section. Show the full code in one message so I can copy and run it locally. Keep it clean and minimal. Do not use web_fetch or web_search for this; just write the code."

GROUP_ID="-5049131940"

echo "Sending website-build test prompt to Macbotd (Agent A)..."
openclaw agent --agent main --channel telegram --to "$GROUP_ID" --message "$MSG" --deliver --thinking off --timeout "$AGENT_TIMEOUT"

echo ""
echo "Sending same prompt for Agent B..."
openclaw agent --agent AdminCreateWebsiteBot --channel telegram --to "$GROUP_ID" --message "$MSG" --deliver --thinking off --timeout "$AGENT_TIMEOUT"

echo ""
echo "Done. Check the Macbotd group for both bots' replies (full HTML/CSS code)."

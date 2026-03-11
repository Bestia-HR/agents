#!/usr/bin/env bash
# Send the full-stack portfolio prompt to Macbotd. Agent A (main) will process and reply in the group.
# By default requires gateway. To avoid "session file locked", run with gateway STOPPED and use
#   RUN_WITHOUT_GATEWAY=1 ./send-portfolio-prompt-macbotd.sh
# or use: ./run-portfolio-prompt-macbotd-safe.sh
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

GATEWAY_URL="${OPENCLAW_GATEWAY_URL:-http://127.0.0.1:18789}"
if [[ "${RUN_WITHOUT_GATEWAY}" != "1" ]]; then
  if ! curl -s -o /dev/null --connect-timeout 5 "$GATEWAY_URL" 2>/dev/null; then
    echo "Error: Gateway not reachable at $GATEWAY_URL"
    echo "Start it first: ./run-gateway.sh"
    echo "Or to run without gateway (stops session lock conflict): RUN_WITHOUT_GATEWAY=1 $0"
    exit 1
  fi
else
  echo "Running in embedded mode (gateway not required). Ensure gateway is stopped to avoid session file locked."
fi

GROUP_ID="-5049131940"
# Default prompt file; ignore first arg if it looks like a comment (e.g. "# in another")
if [[ -n "$1" && "$1" != "#" && "$1" != \#* ]]; then
  PROMPT_FILE="$1"
else
  PROMPT_FILE="prompts/portfolio-fullstack-single-file.txt"
fi
AGENT_TIMEOUT="${OPENCLAW_AGENT_TIMEOUT:-7200}"

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "Error: Prompt file not found: $PROMPT_FILE"
  exit 1
fi

MSG=$(cat "$PROMPT_FILE")
echo "Sending portfolio prompt to Macbotd (Agent A)..."
openclaw agent --agent main --channel telegram --to "$GROUP_ID" --message "$MSG" --deliver --thinking off --timeout "$AGENT_TIMEOUT"

echo ""
echo "Done. Check the Macbotd group for the reply (full HTML file)."

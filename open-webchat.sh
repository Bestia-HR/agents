#!/usr/bin/env bash
# Start the gateway (if not running), wait for it, then open WebChat in your browser.
# Run: ./open-webchat.sh   or   bash open-webchat.sh
set -e
cd "$(dirname "$0")"

export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
mkdir -p "$OPENCLAW_STATE_DIR"

[[ -f .env ]] && set -a && . ./.env && set +a

if [[ -z "${NVIDIA_API_KEY}" ]]; then
  echo "Error: NVIDIA_API_KEY not set. Add it to .env"
  exit 1
fi

# Ensure agent auth store has NVIDIA key (fixes "No API key found for provider nvidia")
[[ -f "$(dirname "$0")/setup-auth.sh" ]] && bash "$(dirname "$0")/setup-auth.sh" || true

PORT=18789
URL="http://127.0.0.1:${PORT}"

# Check if port is already in use (gateway running)
if (command -v nc >/dev/null 2>&1 && nc -z 127.0.0.1 $PORT 2>/dev/null) || \
   (command -v curl >/dev/null 2>&1 && curl -s -o /dev/null --connect-timeout 2 "$URL" 2>/dev/null); then
  echo "Gateway already running. Opening WebChat..."
  open "$URL" 2>/dev/null || xdg-open "$URL" 2>/dev/null || echo "Open in browser: $URL"
  exit 0
fi

# Start gateway in background
echo "Starting OpenClaw gateway on port $PORT..."
openclaw gateway --port "$PORT" --verbose &
GWPID=$!

# Wait until port is up (max 45 sec)
for i in $(seq 1 45); do
  if (command -v nc >/dev/null 2>&1 && nc -z 127.0.0.1 $PORT 2>/dev/null) || \
     (command -v curl >/dev/null 2>&1 && curl -s -o /dev/null --connect-timeout 2 "$URL" 2>/dev/null); then
    echo "Gateway ready. Opening WebChat at $URL"
    open "$URL" 2>/dev/null || xdg-open "$URL" 2>/dev/null || echo "Open in browser: $URL"
    echo "Gateway PID: $GWPID (stop with: kill $GWPID)"
    exit 0
  fi
  sleep 1
done

echo "Gateway did not start in time. Check: openclaw gateway --port $PORT --verbose"
kill $GWPID 2>/dev/null || true
exit 1

#!/usr/bin/env bash
# One-shot: start gateway in background, then run the agent with a message.
# For ongoing chat, use run-gateway.sh in one terminal and run-agent.sh in another.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir -p ~/.openclaw
cp -f openclaw.json ~/.openclaw/openclaw.json

if [[ -f .env ]]; then
  set -a
  source .env
  set +a
  echo "Loaded .env"
else
  echo "Warning: no .env. Copy .env.example to .env and set NVIDIA_API_KEY."
fi

# Start gateway in background
openclaw gateway --port 18789 --verbose &
GWPID=$!
trap "kill $GWPID 2>/dev/null" EXIT

echo "Waiting for gateway to be ready..."
sleep 5

MSG="${1:-Hello, say hi in one sentence.}"
echo "Sending to agent: $MSG"
openclaw agent --message "$MSG" --thinking high

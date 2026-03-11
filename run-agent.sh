#!/usr/bin/env bash
# Run the OpenClaw Agent A (main) from this project.
# Usage: ./run-agent.sh [message]
# Or:    ./run-agent.sh                    # starts gateway in background, then one agent chat

set -e
cd "$(dirname "$0")"

export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
mkdir -p "$OPENCLAW_STATE_DIR"

if [[ -f .env ]]; then
  set -a
  . ./.env
  set +a
fi

if [[ -n "$1" ]]; then
  echo "Sending to agent: $*"
  openclaw agent --agent main --message "$*" --thinking high
else
  echo "Starting gateway on port 18789..."
  openclaw gateway --port 18789 --verbose &
  GWPID=$!
  sleep 5
  echo "Asking agent a test question..."
  openclaw agent --agent main --message "Say hello in one sentence." --thinking high || true
  kill $GWPID 2>/dev/null || true
fi

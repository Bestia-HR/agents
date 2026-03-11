#!/usr/bin/env bash
# Run the AdminCreateWebsiteBot agent (Groq / Llama 3.1 8B). Gateway must be running.
# Usage: ./run-AdminCreateWebsiteBot.sh [message]
#   Or:  ./run-AdminCreateWebsiteBot.sh   # sends a test message
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

if [[ -z "${GROQ_API_KEY}" ]]; then
  echo "Error: GROQ_API_KEY not set. Add it to .env, then run: bash setup-auth.sh"
  exit 1
fi

MSG="${1:-Hello, say you are AdminCreateWebsiteBot and ready to help. One sentence.}"
echo "Sending to AdminCreateWebsiteBot agent: $MSG"
openclaw agent --agent AdminCreateWebsiteBot --message "$MSG" --thinking low

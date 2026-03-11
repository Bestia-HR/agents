#!/usr/bin/env bash
# Send the React 19 personal page task to the agent so it replies in Macbotd.
# Run when gateway is up and rate limit is clear: ./send-react19-task-macbotd.sh
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

MSG="Task to all bots: create personal page design must be in color yellow and black, use React 19 for coding. You can use internet, then merge the ideas and show me the full code."

echo "Sending task to Agent A (main) for Macbotd..."
openclaw agent --agent main --channel telegram --to -5049131940 --message "$MSG" --deliver --thinking medium

echo "Sending task to Agent B (AdminCreateWebsiteBot) for Macbotd..."
openclaw agent --agent AdminCreateWebsiteBot --channel telegram --to -5049131940 --message "$MSG" --deliver --thinking medium

echo "Done. Check the Macbotd group for replies."

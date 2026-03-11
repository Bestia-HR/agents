#!/usr/bin/env bash
# Clear all OpenClaw agent sessions. Stop the gateway first if it's running.
set -e
cd "$(dirname "$0")"
STATE=".openclaw-state"

echo "Stopping gateway so session files are not locked..."
openclaw gateway stop 2>/dev/null || true
lsof -ti :18789 | xargs kill -9 2>/dev/null || true
sleep 1

echo "Clearing Main agent sessions..."
rm -f "$STATE/agents/main/sessions/"*.jsonl "$STATE/agents/main/sessions/"*.jsonl.lock "$STATE/agents/main/sessions/"*.jsonl.reset.* 2>/dev/null || true
echo '{}' > "$STATE/agents/main/sessions/sessions.json"

echo "Clearing AdminCreateWebsiteBot sessions..."
rm -f "$STATE/agents/AdminCreateWebsiteBot/sessions/"*.jsonl "$STATE/agents/AdminCreateWebsiteBot/sessions/"*.jsonl.lock "$STATE/agents/AdminCreateWebsiteBot/sessions/"*.jsonl.reset.* 2>/dev/null || true
echo '{}' > "$STATE/agents/AdminCreateWebsiteBot/sessions/sessions.json"

echo "Done. All sessions cleared. Start the gateway again: ./run-gateway.sh"

#!/usr/bin/env bash
# Quick test that config is valid and agent can run (file access / localhost setup).
# Run from project root. Optional: start gateway first (./run-gateway.sh) for full flow.
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

echo "=== 1. Config validation ==="
if openclaw config validate 2>/dev/null; then
  echo "   OK — openclaw.json is valid."
else
  echo "   FAIL — run: openclaw config validate"
  exit 1
fi

echo ""
echo "=== 2. Agent run (list workspace) ==="
OUT=$(openclaw agent --agent main --message "List the files in the workspace root. Use the read or exec tool, then reply with the file names in one line." --thinking off --timeout 60 2>&1) || true
if echo "$OUT" | grep -qE "AGENTS\.md|package\.json|\.md|\.html"; then
  echo "   OK — Agent returned workspace content (likely used context or tools)."
  echo "   Reply snippet: $(echo "$OUT" | tr '\n' ' ' | head -c 120)..."
else
  echo "   Output: $(echo "$OUT" | tail -5)"
fi

echo ""
echo "=== 3. Custom skills loaded? ==="
if openclaw doctor 2>&1 | grep -q "Eligible:"; then
  echo "   OK — Run 'openclaw doctor' for full skills status."
else
  echo "   Run: openclaw doctor"
fi

echo ""
echo "Done. In Telegram, use the short prompt: 'Open the project on localhost' (no path needed); the agent will find the project and use exec + browser. Restart gateway after config changes: ./run-gateway.sh"

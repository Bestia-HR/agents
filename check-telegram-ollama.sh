#!/usr/bin/env bash
# Quick check: is Ollama running and is the OpenClaw gateway running?
# If both OK, the bot can use local Ollama to respond in Telegram (assuming privacy is off).
set -e
cd "$(dirname "$0")"

echo "=== Ollama (local LLM) ==="
if curl -s -o /dev/null --connect-timeout 2 http://127.0.0.1:11434/api/tags 2>/dev/null; then
  echo "  OK - Ollama is running"
  if curl -s http://127.0.0.1:11434/api/tags 2>/dev/null | grep -q "qwen2.5-coder:7b"; then
    echo "  OK - qwen2.5-coder:7b is available"
  else
    echo "  WARN - qwen2.5-coder:7b not in list. Run: ollama pull qwen2.5-coder:7b"
  fi
else
  echo "  FAIL - Ollama not reachable at http://127.0.0.1:11434"
  echo "         Start it: ollama serve   (then: ollama run qwen2.5-coder:7b)"
fi

echo ""
echo "=== OpenClaw gateway ==="
GATEWAY_URL="${OPENCLAW_GATEWAY_URL:-http://127.0.0.1:18789}"
if curl -s -o /dev/null --connect-timeout 2 "$GATEWAY_URL" 2>/dev/null; then
  echo "  OK - Gateway is running at $GATEWAY_URL"
else
  echo "  FAIL - Gateway not reachable at $GATEWAY_URL"
  echo "         Start it: ./run-gateway.sh"
fi

echo ""
echo "=== Telegram (bot sees your messages) ==="
echo "  If the bot still doesn't reply, disable privacy for BOTH bots:"
echo "  @BotFather → /setprivacy → select each bot → Disable"
echo ""
echo "Then send a message in the Macbotd group; the bot should answer using Ollama."

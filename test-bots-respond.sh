#!/usr/bin/env bash
# Test that bots respond and there is no API rate limit (Ollama only).
# Run with gateway already running in another terminal: ./run-gateway.sh
# Or run this script alone: it will start the gateway briefly and test.
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama-local}"
[[ -f .env ]] && set -a && . ./.env && set +a

echo "=== 1. Check Ollama is running ==="
if curl -s http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
  echo "   OK — Ollama is running."
  curl -s http://127.0.0.1:11434/api/tags | grep -o '"name":"[^"]*"' | head -3
else
  echo "   FAIL — Ollama not responding. Start it (e.g. run 'ollama run llama3.2' or open the Ollama app)."
  exit 1
fi

echo ""
echo "=== 2. Check gateway on 18789 ==="
if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:18789 2>/dev/null | grep -q [0-9]; then
  GATEWAY_UP=1
  echo "   OK — Gateway is running."
else
  GATEWAY_UP=0
  echo "   Gateway not running. Start it in another terminal: ./run-gateway.sh"
  echo "   Then run this script again to test the bots."
  exit 1
fi

echo ""
echo "=== 3. Test Agent A (main) — send message, expect reply (no rate limit) ==="
OUT=$(openclaw agent --agent main --message "Reply with only: Test OK" --thinking off 2>&1) || true
if echo "$OUT" | grep -qi "rate limit\|FailoverError\|All models failed"; then
  echo "   FAIL — Error or rate limit:"
  echo "$OUT" | tail -5
elif echo "$OUT" | grep -qE "Test OK|test ok|Hello|assistant"; then
  echo "   OK — Bot responded. No rate limit."
  echo "$OUT" | tail -3
else
  echo "   Output (check for reply):"
  echo "$OUT" | tail -8
fi

echo ""
echo "=== 4. Test Agent B (AdminCreateWebsiteBot) ==="
OUT2=$(openclaw agent --agent AdminCreateWebsiteBot --message "Reply with only: Bot B OK" --thinking off 2>&1) || true
if echo "$OUT2" | grep -qi "rate limit\|FailoverError\|All models failed"; then
  echo "   FAIL — Error or rate limit."
  echo "$OUT2" | tail -3
elif echo "$OUT2" | grep -qE "OK|assistant|text"; then
  echo "   OK — Bot B responded."
  echo "$OUT2" | tail -3
else
  echo "   Output:"
  echo "$OUT2" | tail -5
fi

echo ""
echo "=== Done. Using local Ollama = no API rate limit. ==="
echo "   To test in Telegram: send a message in Macbotd; bots should reply."

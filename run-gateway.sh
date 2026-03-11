#!/usr/bin/env bash
# Start the OpenClaw gateway (keep running). In another terminal run: ./run-agent.sh "Your question"
set -e
cd "$(dirname "$0")"

export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json"
export OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
mkdir -p "$OPENCLAW_STATE_DIR"

[[ -f .env ]] && set -a && . ./.env && set +a

# Ensure Ollama is registered (Researcher: qwen3:8b, Coder: deepseek-r1:8b); gateway must see this
export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama-local}"
# Keep model loaded to avoid cold-start timeouts (reduces "LLM request timed out")
export OLLAMA_KEEP_ALIVE="${OLLAMA_KEEP_ALIVE:--1}"

# Ensure agent auth store has API keys (Groq, Ollama, etc.)
[[ -x "$(dirname "$0")/setup-auth.sh" ]] && bash "$(dirname "$0")/setup-auth.sh" || true

# Stop any existing gateway on this port so this one can start
openclaw gateway stop 2>/dev/null || true
lsof -ti :18789 | xargs kill -9 2>/dev/null || true
sleep 1

# Warm Ollama so first prompt doesn't time out (optional; skip if Ollama not running)
if curl -s -o /dev/null --connect-timeout 2 http://127.0.0.1:11434/api/tags 2>/dev/null; then
  echo "Warming Ollama (Researcher uses qwen3:8b, Coder uses deepseek-r1:8b)..."
  curl -s -X POST http://127.0.0.1:11434/api/generate \
    -H "Content-Type: application/json" \
    -d '{"model":"qwen3:8b","prompt":"hi","stream":false}' \
    --max-time 120 >/dev/null 2>&1 || true
  echo "Gateway starting at http://127.0.0.1:18789 (WebChat available)"
else
  echo "Ollama not reachable. Start it, then: ollama pull qwen3:8b && ollama pull deepseek-r1:8b"
  echo "Gateway starting at http://127.0.0.1:18789 (WebChat available)"
fi
exec openclaw gateway --port 18789 --verbose

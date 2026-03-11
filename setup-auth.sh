#!/usr/bin/env bash
# Write API keys from .env into OpenClaw agent auth stores (main + AdminCreateWebsiteBot).
# Claude Sonnet 4.6 (Anthropic) primary + Ollama fallback.
set -e
cd "$(dirname "$0")"

[[ -f .env ]] && set -a && . ./.env && set +a

# --- Main agent (Anthropic + Ollama) ---
AGENT_DIR=".openclaw-state/agents/main/agent"
mkdir -p "$AGENT_DIR"
AUTH_FILE="$AGENT_DIR/auth-profiles.json"
export ANTHROPIC_KEY="$ANTHROPIC_API_KEY"
export OLLAMA_MAIN="$OLLAMA_API_KEY"
AUTH_JSON=$(node -e "
const anthropic = process.env.ANTHROPIC_KEY || '';
const ollama = process.env.OLLAMA_MAIN || '';
const profiles = {};
if (anthropic) profiles['anthropic:default'] = { provider: 'anthropic', key: anthropic };
if (ollama) profiles['ollama:default'] = { provider: 'ollama', key: ollama };
console.log(JSON.stringify({ profiles }, null, 2));
" 2>/dev/null)
if [[ -n "$AUTH_JSON" ]]; then
  echo "$AUTH_JSON" > "$AUTH_FILE"
  echo "Wrote auth to $AUTH_FILE (Main agent): Anthropic (Claude Sonnet 4.6) + Ollama."
fi

# --- Agent B (Anthropic + Ollama) ---
AGENT_DIR=".openclaw-state/agents/AdminCreateWebsiteBot/agent"
mkdir -p "$AGENT_DIR"
AUTH_FILE="$AGENT_DIR/auth-profiles.json"
AUTH_JSON=$(node -e "
const anthropic = process.env.ANTHROPIC_KEY || '';
const ollama = process.env.OLLAMA_MAIN || '';
const profiles = {};
if (anthropic) profiles['anthropic:default'] = { provider: 'anthropic', key: anthropic };
if (ollama) profiles['ollama:default'] = { provider: 'ollama', key: ollama };
console.log(JSON.stringify({ profiles }, null, 2));
" 2>/dev/null)
if [[ -n "$AUTH_JSON" ]]; then
  echo "$AUTH_JSON" > "$AUTH_FILE"
  echo "Wrote auth to $AUTH_FILE (Agent B): Anthropic (Claude Sonnet 4.6) + Ollama."
fi

if [[ -z "${ANTHROPIC_API_KEY}" ]]; then
  echo "Note: Set ANTHROPIC_API_KEY in .env (get key from console.anthropic.com) then re-run this script."
fi

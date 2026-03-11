#!/usr/bin/env bash
# Pre-load Ollama model so the first agent reply doesn't time out.
# Leave this running; in another terminal run: ./run-gateway.sh
set -e
cd "$(dirname "$0")"
export OLLAMA_KEEP_ALIVE=-1
echo "Loading qwen2.5-coder:7b (keep this window open)..."
exec ollama run qwen2.5-coder:7b

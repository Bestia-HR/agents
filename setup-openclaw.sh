#!/usr/bin/env bash
# Copy this project's OpenClaw config to ~/.openclaw (merge manually if you already have config).

set -e
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$OPENCLAW_HOME"

if [[ -f "$OPENCLAW_HOME/openclaw.json" ]]; then
  echo "Found existing $OPENCLAW_HOME/openclaw.json — not overwriting."
  echo "Merge agents.defaults.model.primary and tools.web from this project's openclaw.json manually."
else
  cp "$SCRIPT_DIR/openclaw.json" "$OPENCLAW_HOME/openclaw.json"
  echo "Copied openclaw.json to $OPENCLAW_HOME/"
fi

if [[ -f "$SCRIPT_DIR/.env" ]]; then
  echo "Found .env in project; load it before running: export \$(cat .env | xargs)"
else
  echo "Copy .env.example to .env, add NVIDIA_API_KEY (and optionally BRAVE_API_KEY), then: export \$(cat .env | xargs)"
fi

echo ""
echo "Next: openclaw onboard --install-daemon   (first time)"
echo "       openclaw gateway --port 18789 --verbose"
echo "       openclaw agent --message 'Your question' --thinking high"

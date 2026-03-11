#!/usr/bin/env bash
# Web Development AI Stack — status and agents
# Run from agent repo: ./launch-ai.sh
# Or copy to ~/launch-ai.sh for global use.
set -e
cd "$(dirname "$0")"
export OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-$(pwd)/openclaw.json}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-$(pwd)/.openclaw-state}"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  🌐 WEB DEVELOPMENT AI STACK             ║"
echo "╠══════════════════════════════════════════╣"
echo "║  Ollama    → localhost:11434             ║"
echo "║  OpenClaw  → 127.0.0.1:18789 (gateway)   ║"
echo "╠══════════════════════════════════════════╣"
echo "║  🧠 9 WEB DEV AGENTS:                    ║"
echo "║   🏗️  ARCHITECT     (qwen3:8b)            ║"
echo "║   🎨 UI DESIGNER   (qwen3:8b)            ║"
echo "║   ⚛️  FRONTEND DEV  (qwen2.5-coder:7b)   ║"
echo "║   🔌 BACKEND DEV   (qwen2.5-coder:7b)   ║"
echo "║   🗄️  DB ARCHITECT  (qwen2.5-coder:7b)   ║"
echo "║   🔍 SEO           (qwen3:8b)            ║"
echo "║   🔎 REVIEWER      (qwen2.5-coder:7b)   ║"
echo "║   🐛 DEBUGGER      (qwen2.5-coder:7b)   ║"
echo "║   📝 TECH WRITER   (qwen3:8b)            ║"
echo "╠══════════════════════════════════════════╣"
echo "║  ⚡ All messages → Architect → delegates ║"
echo "║  📁 Projects: ~/websites/[name]/        ║"
echo "║  🚀 Launch: ./websites/launch-project.sh ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Optional: show running websites
WEBSITES_ROOT="${WEBSITES_ROOT:-$HOME/websites}"
if [[ -d "$WEBSITES_ROOT" ]] && [[ -n "$(ls -A "$WEBSITES_ROOT" 2>/dev/null)" ]]; then
  echo "📁 Built projects in $WEBSITES_ROOT:"
  for d in "$WEBSITES_ROOT"/*/; do
    [[ -d "$d" ]] || continue
    name=$(basename "$d")
    echo "   → $name"
  done
  echo ""
fi

echo "Start gateway: ./run-gateway.sh"
echo "Commands: /build, /component, /api, /fix, /review, /seo, /ui, /docs, /ecommerce, /projects"
echo ""

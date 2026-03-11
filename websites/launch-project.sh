#!/usr/bin/env bash
# Launch a built website: install deps, start dev server, open browser.
# Usage: ./launch-project.sh [path-to-project]
# Example: ./launch-project.sh ~/websites/coffee-shop
# If no path given, uses first project in ~/websites/ or current dir.
set -e
WEBSITES_ROOT="${WEBSITES_ROOT:-$HOME/websites}"
PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  # Use first directory in ~/websites or current dir
  if [[ -d "$WEBSITES_ROOT" ]] && [[ -n "$(ls -A "$WEBSITES_ROOT" 2>/dev/null)" ]]; then
    PROJECT_PATH=$(find "$WEBSITES_ROOT" -maxdepth 1 -type d ! -path "$WEBSITES_ROOT" | head -1)
  fi
  if [[ -z "$PROJECT_PATH" ]] || [[ ! -d "$PROJECT_PATH" ]]; then
    echo "Usage: $0 <project-path>"
    echo "Example: $0 $WEBSITES_ROOT/my-site"
    exit 1
  fi
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
PROJECT_NAME="$(basename "$PROJECT_PATH")"

# Find first free port (OpenClaw may use 3000)
FREE_PORT=""
for p in 3000 3001 3002 3003 3004 3005; do
  if ! lsof -i :$p >/dev/null 2>&1; then
    FREE_PORT=$p
    break
  fi
done
if [[ -z "$FREE_PORT" ]]; then
  FREE_PORT=3006
fi

echo "📁 Project: $PROJECT_NAME"
echo "📂 Path: $PROJECT_PATH"
echo "🔌 Port: $FREE_PORT"
echo ""

if [[ ! -f "$PROJECT_PATH/package.json" ]]; then
  echo "❌ No package.json in $PROJECT_PATH"
  exit 1
fi

echo "📦 Installing dependencies..."
(cd "$PROJECT_PATH" && npm install) || { echo "❌ npm install failed"; exit 1; }

echo ""
echo "🚀 Starting dev server on port $FREE_PORT..."
export PORT=$FREE_PORT
(cd "$PROJECT_PATH" && npm run dev) &
PID=$!
# Wait for server to be ready (Next.js prints "Ready" or "localhost")
for i in {1..30}; do
  sleep 1
  if curl -s -o /dev/null "http://127.0.0.1:$FREE_PORT" 2>/dev/null; then
    break
  fi
  if ! kill -0 $PID 2>/dev/null; then
    echo "❌ Dev server exited"
    exit 1
  fi
done

echo ""
echo "✅ Website ready!"
echo "🌐 Opening http://localhost:$FREE_PORT"
open "http://localhost:$FREE_PORT" 2>/dev/null || true

echo ""
echo "🎉 WEBSITE READY!"
echo "═══════════════════"
echo "📁 Project: $PROJECT_NAME"
echo "🌐 URL: http://localhost:$FREE_PORT"
echo "📂 Path: $PROJECT_PATH"
echo "✅ Status: running (PID $PID)"
echo ""
echo "To stop: kill $PID  or  ./manager.py stop $PROJECT_NAME"

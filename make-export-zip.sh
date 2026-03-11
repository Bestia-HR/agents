#!/usr/bin/env bash
# Create agent-export.zip with all files needed to copy to another device.
# Puts the zip in /Users/user/copy (or pass a directory as first argument).

set -e
DEST="${1:-/Users/user/copy}"
mkdir -p "$DEST"
cd "$(dirname "$0")"

zip -r "$DEST/agent-export.zip" \
  openclaw.json \
  .env.example \
  run-gateway.ps1 \
  WINDOWS-EXPORT.md \
  EXPORT-AND-MULTI-DEVICE.md \
  FREE-SEARCH-ALTERNATIVES.md \
  README.md \
  setup-auth.sh \
  open-webchat.sh \
  workspace \
  -x "*.git*" \
  -x "*__MACOSX*" \
  -x "*.DS_Store"

[ -f COPY-THESE-FOR-ZIP.txt ] && zip -u "$DEST/agent-export.zip" COPY-THESE-FOR-ZIP.txt
[ -f FILES-TO-COPY.txt ] && zip -u "$DEST/agent-export.zip" FILES-TO-COPY.txt

echo "Created: $DEST/agent-export.zip"

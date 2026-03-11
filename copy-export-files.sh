#!/usr/bin/env bash
# Copy all export files and workspace into /Users/user/copy so you can zip that folder.

set -e
DEST="${1:-/Users/user/copy}"
mkdir -p "$DEST"
cd "$(dirname "$0")"

cp openclaw.json .env.example run-gateway.ps1 WINDOWS-EXPORT.md EXPORT-AND-MULTI-DEVICE.md FREE-SEARCH-ALTERNATIVES.md README.md setup-auth.sh open-webchat.sh "$DEST/" 2>/dev/null || true
[ -f COPY-THESE-FOR-ZIP.txt ] && cp COPY-THESE-FOR-ZIP.txt "$DEST/"
[ -f FILES-TO-COPY.txt ] && cp FILES-TO-COPY.txt "$DEST/"
rm -rf "$DEST/workspace"
cp -R workspace "$DEST/"

echo "Copied export files to $DEST"
echo "Zip that folder: cd $DEST && zip -r agent-export.zip . -x README.txt -x '*.zip'"

#!/usr/bin/env bash
# Uruchamia Cursor Cloud Agenta (API) z podanym promptem i repozytorium.
# Wymaga: CURSOR_API_KEY w .env lub środowisku.
# Dokumentacja: docs/CURSOR-AGENT-INTEGRATION.md
#
# Użycie:
#   ./scripts/cursor-cloud-agent.sh "Add README with install instructions" https://github.com/org/repo
#   ./scripts/cursor-cloud-agent.sh "Fix lint in src/" https://github.com/org/repo --branch main --pr
#   ./scripts/cursor-cloud-agent.sh "Review open PRs" https://github.com/org/repo --pr-url "https://github.com/org/repo/pull/42"
#
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

if [[ -f .env ]]; then
  set -a
  . ./.env
  set +a
fi

if [[ -z "$CURSOR_API_KEY" ]]; then
  echo "Błąd: ustaw CURSOR_API_KEY (w .env lub export). Klucz: Cursor Dashboard → Integrations." >&2
  exit 1
fi

PROMPT="${1:-}"
shift || true
REPO=""
BRANCH=""
AUTO_PR="false"
PR_URL=""
MODEL=""

while [[ -n "$1" ]]; do
  case "$1" in
    --branch)   BRANCH="$2"; shift 2 ;;
    --pr)       AUTO_PR="true"; shift ;;
    --pr-url)   PR_URL="$2"; shift 2 ;;
    --model)    MODEL="$2"; shift 2 ;;
    -*)         echo "Nieznana opcja: $1" >&2; exit 1 ;;
    *)          [[ -z "$REPO" ]] && REPO="$1"; shift ;;
  esac
done

if [[ -z "$PROMPT" ]]; then
  echo "Użycie: $0 \"<prompt>\" \"<repo_url>\" [--branch BRANCH] [--pr] [--pr-url URL] [--model MODEL]" >&2
  echo "  albo:  $0 \"<prompt>\" --pr-url \"<pull_request_url>\"" >&2
  echo "  --branch BRANCH   ref (branch/tag/commit), np. main" >&2
  echo "  --pr              auto-create PR po zakończeniu" >&2
  echo "  --pr-url URL      praca na istniejącym PR (wtedy repo z URL)" >&2
  echo "  --model MODEL     np. claude-4.5-sonnet-thinking lub default" >&2
  exit 1
fi
if [[ -z "$PR_URL" && -z "$REPO" ]]; then
  echo "Błąd: podaj repo_url albo --pr-url." >&2
  exit 1
fi

# URL bez końcówki .git (API może nie rozpoznawać)
[[ -n "$REPO" ]] && REPO="${REPO%.git}"

# Budowa body JSON (ref tylko gdy podano --branch; inaczej API bierze default z GitHub)
SOURCE_JSON=""
if [[ -n "$PR_URL" ]]; then
  SOURCE_JSON="\"prUrl\": \"$PR_URL\""
else
  SOURCE_JSON="\"repository\": \"$REPO\""
  [[ -n "$BRANCH" ]] && SOURCE_JSON="$SOURCE_JSON, \"ref\": \"$BRANCH\""
fi

TARGET_JSON="\"autoCreatePr\": $AUTO_PR"
MODEL_JSON=""
[[ -n "$MODEL" ]] && MODEL_JSON=", \"model\": \"$MODEL\""

# Escape prompt do JSON (prosty escape cudzysłowów i backslash)
PROMPT_ESC="${PROMPT//\\/\\\\}"
PROMPT_ESC="${PROMPT_ESC//\"/\\\"}"

BODY="{
  \"prompt\": { \"text\": \"$PROMPT_ESC\" },
  \"source\": { $SOURCE_JSON }
  $MODEL_JSON
  , \"target\": { $TARGET_JSON }
}"

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.cursor.com/v0/agents" \
  -u "$CURSOR_API_KEY:" \
  -H "Content-Type: application/json" \
  -d "$BODY")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY_ONLY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" -lt 200 || "$HTTP_CODE" -ge 300 ]]; then
  echo "API zwróciło HTTP $HTTP_CODE" >&2
  echo "$BODY_ONLY" | head -c 2000 >&2
  exit 1
fi

echo "$BODY_ONLY" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    aid = d.get('id') or d.get('agent_id')
    status = d.get('status', '')
    url = (d.get('target') or {}).get('url') or ''
    print('Agent ID:', aid)
    print('Status:', status)
    if url:
        print('URL:', url)
except Exception as e:
    print(sys.stdin.read())
    raise e
"

#!/usr/bin/env bash
# Krok 1: Cursor dostaje prompt użytkownika i tworzy PLAN.md w repo (szczegółowy podział na subagentów).
# Skrypt uruchamia Cursor Cloud Agenta, czeka na zakończenie, pobiera plan (artifacts lub konwersację) i wypisuje go na stdout.
# Użycie: ./scripts/cursor-plan.sh "user prompt" "https://github.com/org/repo"
# Wymaga: CURSOR_API_KEY w .env. Repo musi istnieć na GitHubie.
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
  echo "Błąd: ustaw CURSOR_API_KEY (w .env)." >&2
  exit 1
fi

USER_PROMPT="${1:-}"
REPO="${2:-}"
REPO="${REPO%.git}"
POLL_INTERVAL="${CURSOR_PLAN_POLL_INTERVAL:-30}"
MAX_WAIT="${CURSOR_PLAN_MAX_WAIT:-600}"

if [[ -z "$USER_PROMPT" || -z "$REPO" ]]; then
  echo "Użycie: $0 \"<user_prompt>\" \"<repo_url>\"" >&2
  exit 1
fi

# Cursor = architekt: MUSI przydzielać szczegółowe, konkretne TASKi (subagenci dostają tylko ten tekst)
BODY=$(USER_PROMPT="$USER_PROMPT" REPO="$REPO" python3 -c '
import json, os
u = os.environ.get("USER_PROMPT", "")[:24000]
r = os.environ.get("REPO", "")
t = """You are the PROJECT ARCHITECT. Your output will be sent to specialist sub-agents who receive ONLY the TASK text for their role. They have no other context. So every TASK must be SELF-CONTAINED, SPECIFIC, and UNMISTAKABLE.

CRITICAL: Each TASK must be 3-6 sentences. Include concrete names, numbers, or lists where applicable. FORBIDDEN: "as needed", "appropriate", "etc.", "and similar", "various", "relevant" — replace with explicit choices.

User request:
---
""" + u + """
---

Create a single file PLAN.md in the repository root. Use EXACTLY this structure (keep the headers). Fill each TASK with real content, not placeholders:

## PROJECT_NAME
<slug e.g. coffee-shop>

## TECH_STACK
<e.g. Next.js 14 App Router, Tailwind CSS, Supabase, TypeScript>

## ui-designer
TASK: <MUST include: (1) color palette with exact hex or Tailwind names for primary/secondary/background, (2) typography: font families and sizes for heading/body, (3) spacing scale or Tailwind spacing to use, (4) list of components to define by name (e.g. Hero, NavBar, Footer, CTAButton), (5) layout rules e.g. max-width, grid columns. Write full sentences.>

## frontend
TASK: <MUST include: (1) list of pages/routes to create (e.g. /, /about, /contact), (2) list of React components to implement with brief responsibility for each, (3) which design tokens or Tailwind classes to use from the design system, (4) any props or data shape for key components. Reference the ui-designer section.>

## backend
TASK: <MUST include: (1) list of API routes or server actions with method and purpose (e.g. GET /api/products, POST /api/contact), (2) Supabase tables or functions to call, (3) env vars required (names only).>

## database
TASK: <MUST include: (1) table names and columns with types (e.g. products: id uuid, name text, price numeric), (2) RLS policy in one sentence per table if needed, (3) migration or schema file to create.>

## seo
TASK: <MUST include: (1) page title and meta description pattern, (2) Open Graph image or placeholder requirement, (3) schema.org type to add (e.g. LocalBusiness, Organization) and which pages.>

## reviewer
TASK: <MUST include: (1) specific checks: e.g. "no console.log in prod", "all images have alt", "Lighthouse Performance > 85", (2) security: "no secrets in client bundle", (3) list 3-4 concrete review criteria.>

Example of BAD TASK: "Create a design system as needed."
Example of GOOD TASK: "Define a design system: primary color #1a1a2e, secondary #16213e, background #0f0f23. Use Inter for body (text-base) and Space Grotesk for headings (text-2xl). Define components: Hero (full-width, centered title + CTA), NavBar (sticky, 4 links), Footer (3 columns). Use Tailwind spacing-4 and max-w-6xl for content. Write tailwind.config.js with these tokens."

Write PLAN.md with this level of detail for every section. Then commit and push."""
print(json.dumps({"prompt":{"text":t},"source":{"repository":r},"target":{"autoCreatePr":False}}))
')

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.cursor.com/v0/agents" \
  -u "$CURSOR_API_KEY:" \
  -H "Content-Type: application/json" \
  -d "$BODY")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY_ONLY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" -lt 200 || "$HTTP_CODE" -ge 300 ]]; then
  echo "Cursor API HTTP $HTTP_CODE" >&2
  echo "$BODY_ONLY" | head -c 2000 >&2
  exit 1
fi

AGENT_ID=$(echo "$BODY_ONLY" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('id', ''))
")

if [[ -z "$AGENT_ID" ]]; then
  echo "Brak agent ID w odpowiedzi" >&2
  exit 1
fi

echo "Cursor agent: $AGENT_ID (czekam do ${MAX_WAIT}s)" >&2

# Poll until FINISHED or FAILED
ELAPSED=0
while [[ $ELAPSED -lt $MAX_WAIT ]]; do
  sleep "$POLL_INTERVAL"
  ELAPSED=$((ELAPSED + POLL_INTERVAL))
  STATUS_RESP=$(curl -s -u "$CURSOR_API_KEY:" "https://api.cursor.com/v0/agents/$AGENT_ID")
  STATUS=$(echo "$STATUS_RESP" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('status', ''))
except: print('')
" 2>/dev/null)
  echo "  status: $STATUS (${ELAPSED}s)" >&2
  if [[ "$STATUS" = "FINISHED" ]]; then
    break
  fi
  if [[ "$STATUS" = "FAILED" ]] || [[ "$STATUS" = "CANCELLED" ]]; then
    echo "Cursor zakończył ze statusem: $STATUS" >&2
    # Still try to get conversation
    break
  fi
done

# Try artifacts first (PLAN.md)
ARTIFACTS_JSON=$(curl -s -u "$CURSOR_API_KEY:" "https://api.cursor.com/v0/agents/$AGENT_ID/artifacts" 2>/dev/null)
PLAN_PATH=$(echo "$ARTIFACTS_JSON" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for a in d.get('artifacts', []):
        p = a.get('absolutePath', '')
        if 'PLAN' in p or (p.endswith('.md') and 'plan' in p.lower()):
            print(p)
            break
except: pass
" 2>/dev/null)

if [[ -n "$PLAN_PATH" ]]; then
  ENCODED_PATH=$(PLAN_PATH="$PLAN_PATH" python3 -c 'import urllib.parse, os; print(urllib.parse.quote(os.environ.get("PLAN_PATH","")))' 2>/dev/null)
  DOWNLOAD_JSON=$(curl -s -u "$CURSOR_API_KEY:" "https://api.cursor.com/v0/agents/$AGENT_ID/artifacts/download?path=$ENCODED_PATH" 2>/dev/null)
  DOWNLOAD_URL=$(echo "$DOWNLOAD_JSON" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('url', ''))
except: pass
" 2>/dev/null)
  if [[ -n "$DOWNLOAD_URL" ]]; then
    curl -sL "$DOWNLOAD_URL" 2>/dev/null
    exit 0
  fi
fi

# Fallback: conversation (last assistant message with plan-like content)
CONV_JSON=$(curl -s -u "$CURSOR_API_KEY:" "https://api.cursor.com/v0/agents/$AGENT_ID/conversation" 2>/dev/null)
echo "$CONV_JSON" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for m in reversed(d.get('messages', [])):
        if m.get('type') == 'assistant_message':
            t = m.get('text', '')
            if 'PROJECT_NAME' in t or '## ui-designer' in t or 'TASK:' in t:
                print(t)
                break
except Exception as e:
    pass
" 2>/dev/null

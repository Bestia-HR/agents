#!/usr/bin/env bash
# Tworzy repo na GitHubie, klonuje lokalnie, opcjonalnie scaffold (Next.js/Vite), uruchamia na localhost.
# Wymaga: gh (GitHub CLI) zalogowane LUB GITHUB_TOKEN w .env.
#
# Użycie:
#   ./scripts/create-repo-and-launch.sh my-app
#   ./scripts/create-repo-and-launch.sh my-app --template vite
#   ./scripts/create-repo-and-launch.sh my-app --template next --org my-org
#   ./scripts/create-repo-and-launch.sh my-app --private
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

REPO_NAME="${1:-}"
TEMPLATE="next"
ORG=""
VISIBILITY="--public"
LAUNCH_SCRIPT="${LAUNCH_SCRIPT:-$REPO_ROOT/websites/launch-project.sh}"

while [[ -n "$1" ]]; do
  case "$1" in
    --template) TEMPLATE="$2"; shift 2 ;;
    --org)      ORG="$2"; shift 2 ;;
    --private)  VISIBILITY="--private"; shift ;;
    --no-launch) NO_LAUNCH=1; shift ;;
    -*)         echo "Opcja: --template next|vite|empty, --org ORG, --private, --no-launch" >&2; exit 1 ;;
    *)          [[ -z "$REPO_NAME" ]] && REPO_NAME="$1"; shift ;;
  esac
done

if [[ -z "$REPO_NAME" ]]; then
  echo "Użycie: $0 NAZWA_REPO [--template next|vite|empty] [--org ORG] [--private] [--no-launch]" >&2
  echo "  --template next  (domyślnie) scaffold Next.js, potem uruchom na localhost" >&2
  echo "  --template vite  scaffold Vite (React), potem localhost" >&2
  echo "  --template empty tylko repo + clone, bez scaffoldu (localhost pomijane)" >&2
  exit 1
fi

WEBSITES_ROOT="${WEBSITES_ROOT:-$HOME/websites}"
mkdir -p "$WEBSITES_ROOT"
TARGET_DIR="$WEBSITES_ROOT/$REPO_NAME"

if [[ -d "$TARGET_DIR" ]]; then
  echo "Katalog już istnieje: $TARGET_DIR" >&2
  echo "Uruchamiam launch na istniejącym projekcie." >&2
  if [[ -z "$NO_LAUNCH" ]] && [[ -f "$LAUNCH_SCRIPT" ]]; then
    exec "$LAUNCH_SCRIPT" "$TARGET_DIR"
  fi
  exit 0
fi

# --- Tworzenie repo na GitHubie + clone ---
REPO_PATH="$WEBSITES_ROOT/$REPO_NAME"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  echo "Tworzenie repo na GitHubie (gh): $REPO_NAME $VISIBILITY"
  if [[ -n "$ORG" ]]; then
    (cd "$WEBSITES_ROOT" && gh repo create "$ORG/$REPO_NAME" $VISIBILITY --clone)
  else
    (cd "$WEBSITES_ROOT" && gh repo create "$REPO_NAME" $VISIBILITY --clone)
  fi
elif [[ -n "$GITHUB_TOKEN" ]]; then
  echo "Tworzenie repo (GitHub API)..."
  USER_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)
  LOGIN=$(echo "$USER_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('login',''))")
  if [[ -z "$LOGIN" ]]; then
    echo "Błąd: nie udało się pobrać użytkownika GitHub (sprawdź GITHUB_TOKEN)." >&2
    exit 1
  fi
  if [[ -n "$ORG" ]]; then
    CREATOR="orgs/$ORG/repos"
    FULL_NAME="$ORG/$REPO_NAME"
  else
    CREATOR="user/repos"
    FULL_NAME="$LOGIN/$REPO_NAME"
  fi
  curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/$CREATOR" \
    -d "{\"name\":\"$REPO_NAME\",\"private\":$( [[ "$VISIBILITY" = --private ]] && echo true || echo false )}" >/dev/null
  echo "Klonowanie do $TARGET_DIR..."
  git clone "https://${GITHUB_TOKEN}@github.com/${FULL_NAME}.git" "$TARGET_DIR"
  REPO_PATH="$TARGET_DIR"
else
  echo "Błąd: Zainstaluj i zaloguj się w GitHub CLI (gh auth login) LUB ustaw GITHUB_TOKEN w .env" >&2
  exit 1
fi

cd "$REPO_PATH"

# --- Scaffold (Next.js / Vite) ---
if [[ "$TEMPLATE" = "next" ]]; then
  echo "Scaffold: Next.js..."
  npx create-next-app@latest . --yes --ts --tailwind --eslint --app --src-dir 2>/dev/null || true
  [[ ! -f package.json ]] && npx create-next-app@latest . --yes 2>/dev/null || true
elif [[ "$TEMPLATE" = "vite" ]]; then
  echo "Scaffold: Vite (React)..."
  npm create vite@latest . -- --template react-ts 2>/dev/null || true
  [[ ! -f package.json ]] && npm create vite@latest . -- --template react-ts 2>/dev/null || true
fi

if [[ -f package.json ]]; then
  git add -A 2>/dev/null || true
  git commit -m "Initial: scaffold $TEMPLATE" 2>/dev/null || true
  git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null || true
fi

# --- Uruchomienie na localhost ---
if [[ -z "$NO_LAUNCH" ]] && [[ -f package.json ]] && [[ -f "$LAUNCH_SCRIPT" ]]; then
  echo ""
  exec "$LAUNCH_SCRIPT" "$REPO_PATH"
else
  echo ""
  echo "Gotowe: $REPO_PATH"
  echo "Uruchom lokalnie: $LAUNCH_SCRIPT $REPO_PATH"
fi

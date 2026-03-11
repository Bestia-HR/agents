---
name: cursor-cloud-agent
description: Launch Cursor Cloud Agents to work on GitHub repositories. Use when the user wants Cursor (Composer-style) to change code in a GitHub repo, add README, fix issues, or run a coding task on a repo via Cursor's cloud API.
---

# Cursor Cloud Agent — zlecanie zadań na repo GitHub

Użyj tego skilla, gdy użytkownik chce, żeby **Cursor** (Cloud Agent / Composer) coś zrobił w **repozytorium na GitHubie**: dodał README, naprawił kod, zrefaktorował, zrobił PR itd. Skrypt uruchamia agenta Cursor przez API; agent działa w chmurze na wskazanym repo.

## Wymagania

- W `.env` w **głównym katalogu projektu agenta** (tam gdzie `openclaw.json`) musi być ustawione **`CURSOR_API_KEY`** (klucz z Cursor Dashboard → Integrations).
- Repozytorium musi być na **GitHubie** i dostępne dla konta powiązanego z kluczem Cursor.

## Uruchomienie agenta Cursor

**Workdir:** katalog, w którym leży `openclaw.json` i folder `scripts/` (główny katalog projektu agenta). Stąd skrypt ładuje `.env` z `CURSOR_API_KEY`.  
**Command:** wywołanie skryptu z promptem i URL repo.

```bash
./scripts/cursor-cloud-agent.sh "OPIS_ZADANIA" "https://github.com/ORG/REPO"
```

Opcje (dodaj na końcu w razie potrzeby):

- `--pr` — po zakończeniu Cursor utworzy Pull Request
- `--branch NAZWA` — branch (np. `main`, `master`), gdy API nie wykrywa domyślnego
- `--pr-url "https://github.com/.../pull/N"` — praca na istniejącym PR (wtedy nie podawaj repo w drugim argumencie)

## Kiedy używać

- Użytkownik prosi o **zmiany w repozytorium GitHub** (np. „dodaj README w repo X”, „napraw lint w repo Y”, „zrób refactor w Bestia-HR/Flowers-”).
- Użytkownik mówi wprost o **Cursorze** lub **Composerze** w kontekście repo („niech Cursor to zrobi w repo”, „uruchom Cursor na tym repo”).

## Po uruchomieniu

1. Skrypt zwraca **Agent ID** i **URL** (np. `https://cursor.com/agents?id=bc_xxx`).
2. Przekaż użytkownikowi ten **URL** — może tam śledzić postęp i konwersację.
3. Status i konwersację można też sprawdzić przez API (GET `/v0/agents/{id}`, GET `/v0/agents/{id}/conversation`).

## Przykłady (exec)

| Zadanie użytkownika | workdir | command |
|---------------------|--------|--------|
| „Dodaj README w repo Bestia-HR/Flowers-” | `/Users/user/agent` | `./scripts/cursor-cloud-agent.sh "Add a short README with project name and how to run it" "https://github.com/Bestia-HR/Flowers-"` |
| „Niech Cursor naprawi lint w org/repo i zrobi PR” | `/Users/user/agent` | `./scripts/cursor-cloud-agent.sh "Fix all lint errors in the project" "https://github.com/org/repo" --pr` |
| Praca na istniejącym PR | `/Users/user/agent` | `./scripts/cursor-cloud-agent.sh "Add tests for the new endpoint" --pr-url "https://github.com/org/repo/pull/42"` |

## Dokumentacja

Szczegóły API i przepływu: [docs/CURSOR-AGENT-INTEGRATION.md](docs/CURSOR-AGENT-INTEGRATION.md) w katalogu projektu agenta.

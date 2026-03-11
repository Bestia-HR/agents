---
name: cursor-plan
description: Cursor acts as the project architect: it receives the user prompt and produces a detailed PLAN.md with specific tasks per sub-agent. Use when following the standard build flow: Cursor plans, you parse and delegate exactly those TASKs, then open project on localhost.
---

# Cursor plan — Cursor jako architekt

**Cursor jest architektem**: dostaje pierwszy prompt i rozplanowuje wszystkie taski jak najlepiej i najszczegółowiej (PLAN.md). Każdy TASK dla subagenta ma być konkretny (2–5 zdań), bez placeholders. Ty tylko parsujesz plan i delegujesz dokładnie te TASK do agentów, na końcu uruchamiasz localhost.

## Kiedy używać

- W **standardowym przepływie build** (landing, e‑commerce, /build, „zbuduj stronę”): najpierw uruchamiasz **cursor-plan.sh** z promptem użytkownika i URL repo, potem parsujesz wynik i delegujesz.

## Wymagania

- **CURSOR_API_KEY** w `.env` (katalog z openclaw.json).
- Repo na GitHubie (np. utworzone wcześniej przez create-repo-and-launch NAZWA --no-launch).

## Polecenie

**Workdir:** katalog z `openclaw.json` i `scripts/`.

```bash
./scripts/cursor-plan.sh "PEŁNY_PROMPT_UŻYTKOWNIKA" "https://github.com/OWNER/REPO"
```

Skrypt:
1. Wysyła do Cursor Cloud Agenta prompt: „stwórz PLAN.md z podziałem na zadania dla ui-designer, frontend, backend, database, seo, reviewer”.
2. Czeka na zakończenie (poll do ok. 10 min).
3. Pobiera PLAN.md (artifacts lub konwersację) i **wypisuje na stdout**.

## Dlaczego TASKi muszą być szczegółowe

Subagenci dostają **tylko** tekst TASK (bez całego PLAN.md ani kontekstu). Dlatego w skrypcie Cursor dostaje instrukcję: każdy TASK ma być **samodzielny**, **konkretny** (np. nazwy komponentów, hex kolorów, listy route’ów), bez zwrotów w stylu „as needed” czy „appropriate”. W promptcie jest też przykład złego vs dobrego TASK i listy „MUST include” per agent. Jeśli Cursor i tak zwraca ogólniki, można w Telegramie doprecyzować prompt (np. „zbuduj landing z dokładną specyfikacją kolorów i listą komponentów”).

## Format planu (do parsowania)

Wynik zawiera m.in.:
- `## PROJECT_NAME` — slug (np. my-app) do katalogu ~/websites/PROJECT_NAME.
- Dla każdego agenta: `## agent_id` (ui-designer, frontend, backend, database, seo, reviewer) i blok `TASK: ...`.

Po uruchomieniu skryptu **sparsuj** stdout, wyciągnij PROJECT_NAME i każdy TASK, potem **sessions_send** do odpowiedniego agenta z treścią TASK. Na końcu **exec** `./websites/launch-project.sh ~/websites/PROJECT_NAME`.

## Przepływ

1. create-repo-and-launch.sh NAZWA --no-launch  
2. cursor-plan.sh "prompt" "https://github.com/.../NAZWA"  
3. Parsuj PLAN.md → sessions_send do każdego agenta  
4. launch-project.sh ~/websites/PROJECT_NAME  
5. Odpowiedź użytkownikowi z localhost i podsumowaniem  

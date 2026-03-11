# Integracja agenta z Cursorem (Cloud Agents API)

Ten dokument opisuje, jak zbudować agenta, który **używa Cursora** do pracy nad kodem — konkretnie **Cursor Cloud Agents API** (programatyczne uruchamianie agentów w stylu Composer).

## Przepływ: Telegram → OpenClaw → Cursor

- **Wejście:** Wszystkie prompty użytkownika wchodzą **przez Telegram** (boty powiązane z agentem Architect w OpenClaw).
- **OpenClaw:** Architect jest głównym koordynatorem. Działa na OpenClaw, planuje i deleguje.
- **Cursor jako główne AI do repo:** Gdy zadanie dotyczy repozytorium GitHub (zmiany w kodzie, README, refactor, PR), Architect **nie** deleguje na agentów OpenClaw — używa skilla **cursor-cloud-agent** i uruchamia Cursor Cloud Agenta (skrypt `scripts/cursor-cloud-agent.sh`). Użytkownik dostaje link do agenta Cursor i tam śledzi postęp.
- **Pozostałe zadania:** Strony, API, design, dokumentacja — Architect planuje i deleguje na agentów OpenClaw (ui-designer, frontend, backend, database, seo, reviewer, debugger, writer).

Konfiguracja: `workspace-architect/AGENTS.md`, `workspace-architect/IDENTITY.md`, skill `skills/cursor-cloud-agent/SKILL.md`.

## Co to jest Cursor Cloud Agents API?

- **Cloud Agents** = agenty AI Cursora działające w chmurze na Twoim repozytorium (GitHub).
- Działają jak **Composer** w Cursorze: analizują repo, edytują pliki, mogą tworzyć PR.
- API pozwala: **uruchomić** agenta (POST), **sprawdzić status**, **dodać follow-up**, **pobrać konwersację**, **zatrzymać** lub **usunąć** agenta.

## Composer vs Cloud Agents API

| | Composer (w IDE) | Cloud Agents API |
|---|------------------|------------------|
| Gdzie | W Cursorze (⌘I), lokalnie | W chmurze, przez HTTP |
| Sterowanie | Ręcznie w edytorze | Programowo (skrypty, OpenClaw, cron) |
| Repo | Otwarty folder/projekt | URL repo GitHub (wymagane) |
| Użycie | Interaktywne | Automatyzacja, pipeline, drugi agent |

**Agent „korzystający z Cursora”** w tym kontekście = agent (np. OpenClaw, skrypt, inny orchestrator), który **wywołuje Cloud Agents API**, żeby Cursor w imieniu użytkownika wykonał zadanie na repozytorium.

## Wymagania

1. **Klucz API Cursor**  
   - Dashboard → [cursor.com/dashboard](https://cursor.com/dashboard) → **Integrations** → utwórz API key.  
   - Używany jest do **Cloud Agents API** (nie do samego IDE).

2. **Repozytorium na GitHubie**  
   - Cloud Agents działają na repo (URL, branch/ref). Dla pracy na lokalnym folderze bez GitHubu API nie wystarczy — wtedy pozostaje ręczne używanie Composera w Cursorze.

3. **Zmienna środowiskowa** (dla skryptów):  
   W pliku `.env` (lub export): `CURSOR_API_KEY=<twój_klucz>`

## Endpointy (podstawy)

- **Baza:** `https://api.cursor.com`
- **Autoryzacja:** Basic Auth: `-u "$CURSOR_API_KEY:"` (hasło puste).

| Akcja | Metoda | Endpoint |
|-------|--------|----------|
| Uruchom agenta | POST | `/v0/agents` |
| Lista agentów | GET | `/v0/agents` |
| Status agenta | GET | `/v0/agents/{id}` |
| Konwersacja | GET | `/v0/agents/{id}/conversation` |
| Follow-up | POST | `/v0/agents/{id}/followup` |
| Zatrzymaj | POST | `/v0/agents/{id}/stop` |
| Usuń | DELETE | `/v0/agents/{id}` |
| Lista modeli | GET | `/v0/models` |
| Lista repo | GET | `/v0/repositories` |

Szczegóły request/response: [Cursor Cloud Agents API – Endpoints](https://cursor.com/docs/cloud-agent/api/endpoints), [OpenAPI](https://cursor.com/docs-static/cloud-agents-openapi.yaml).

## Jak zbudować „agenta używającego Cursora”

### 1. Prosty skrypt (bash)

W repozytorium jest skrypt **`scripts/cursor-cloud-agent.sh`**:

- Uruchamia Cloud Agenta z podanym promptem i repo.
- Opcjonalnie: branch, auto-PR, wybór modelu.
- Wymaga: `CURSOR_API_KEY` w env.

Użycie pozwala np. z cronu lub z innego agenta (OpenClaw) wywołać Cursora do konkretnego zadania na GitHubie.

### 2. OpenClaw jako orchestrator

- Jeden agent OpenClaw może **decydować**, że zadanie ma wykonać Cursor (np. „zrefaktoruj endpoint X w repo Y”).
- OpenClaw wywołuje skrypt lub bezpośrednio `curl` do `POST /v0/agents` z:
  - `prompt.text` = opis zadania,
  - `source.repository` = URL repo GitHub,
  - opcjonalnie `source.ref`, `target.autoCreatePr`, `model`.
- Potem może sprawdzać status (`GET /v0/agents/{id}`) i np. wysłać follow-up (`POST /v0/agents/{id}/followup`).

Do wywołań HTTP z OpenClaw można użyć narzędzi (tools) albo zadań wykonywanych w środowisku (np. wywołanie skryptu przez shell).

### 3. Composer w IDE (bez API)

Jeśli chcesz, żeby **tylko człowiek** używał Cursora w trybie Composer:

- Otwierasz projekt w Cursorze i używasz **Composer** (⌘I / Ctrl+I).
- To nie wymaga Cloud Agents API — to lokalna sesja w edytorze.  
Integracja „agent → Cursor” w tym dokumencie dotyczy **Cloud Agents API**, nie bezpośrednio Composera w GUI.

## Przykład: uruchomienie agenta (curl)

```bash
export CURSOR_API_KEY="key_..."
curl -s -X POST "https://api.cursor.com/v0/agents" \
  -u "$CURSOR_API_KEY:" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": { "text": "Add a README with installation and usage." },
    "source": {
      "repository": "https://github.com/your-org/your-repo",
      "ref": "main"
    },
    "target": { "autoCreatePr": true }
  }'
```

Odpowiedź zawiera `id` agenta; potem możesz sprawdzać status i konwersację pod `/v0/agents/{id}` oraz `/v0/agents/{id}/conversation`.

## Podsumowanie

- **OpenClaw** jest już na najnowszej wersji (2026.3.2); aktualizacja: `npm i -g openclaw@latest`.
- **Agent „używający Cursora”** = dowolny proces (skrypt, OpenClaw, cron), który wywołuje **Cursor Cloud Agents API** z `CURSOR_API_KEY`.
- Do automatyzacji służy skrypt `scripts/cursor-cloud-agent.sh` i ten dokument; do pełnej specyfikacji — oficjalna dokumentacja i OpenAPI Cursora.

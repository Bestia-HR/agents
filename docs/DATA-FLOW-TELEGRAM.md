# Przepływ danych: prompt w Telegramie → odpowiedź

Opis tego, co się dzieje od wpisania wiadomości w chacie Telegram do otrzymania odpowiedzi.

---

## Schemat ogólny

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  TELEGRAM (użytkownik)                                                            │
│  Wpisujesz prompt w grupie lub DM do bota (main / admin)                          │
└───────────────────────────────────────────┬─────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  OPENCLAW GATEWAY (localhost, port 18789)                                        │
│  • Odbiera webhook / long polling od Telegram (bot token)                          │
│  • Sprawdza allowFrom / groupPolicy (np. grupa -5049131940, user 8455470574)     │
└───────────────────────────────────────────┬─────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  BINDINGS (openclaw.json → bindings)                                              │
│  • channel: telegram, accountId: main  → agentId: architect                       │
│  • channel: telegram, accountId: admin → agentId: architect                       │
│  → Wiadomość trafia do agenta ARCHITECT                                            │
└───────────────────────────────────────────┬─────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ARCHITECT (wykonawca planu Cursora)                                             │
│  • Cursor = architekt planowania (szczegółowy PLAN.md); Architect tylko wykonuje │
│  • Workspace: workspace-architect (IDENTITY.md, AGENTS.md, SOUL.md)              │
│  • Model: ollama/qwen3:8b                                                        │
│  • exec, read, write, edit, sessions_send, skills                                 │
└───────────────────────────────────────────┬─────────────────────────────────────┘
                                            │
              ┌─────────────────────────────┼─────────────────────────────┐
              │                             │                             │
              ▼                             ▼                             ▼
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────────────────────────┐
│  Pojedyncze zadanie │     │  Tylko „stwórz repo  │     │  Build / projekt (landing, e‑commerce)  │
│  w repo GitHub?     │     │  i otwórz localhost”│     │  → CURSOR JAKO ARCHITEKT (plan):        │
│  → cursor-cloud-    │     │  → create-repo-and-   │     │  1. create-repo-and-launch NAZWA        │
│    agent            │     │    launch (skill)    │     │     --no-launch                           │
│  → URL Cursor       │     │  → launch localhost  │     │  2. cursor-plan.sh "prompt" "repo_url"   │
└─────────────────────┘     └─────────────────────┘     │     → Cursor tworzy PLAN.md             │
                                                        │  3. Parsuj PLAN.md → sessions_send       │
                                                        │     do ui-designer, frontend, backend,    │
                                                        │     database, seo, reviewer (TASK z planu)│
                                                        │  4. Na końcu: launch-project.sh           │
                                                        │     ~/websites/PROJECT_NAME (localhost)   │
                                                        └─────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ODPOWIEDŹ DO UŻYTKOWNIKA                                                        │
│  Architect zbiera wyniki (swoje exec, odpowiedzi agentów, link Cursor itd.)      │
│  i wysyła jedną (lub wiele) wiadomości z powrotem przez gateway do Telegram.     │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Kroki krok po kroku

| Krok | Gdzie | Co się dzieje |
|------|--------|----------------|
| 1 | **Telegram** | Użytkownik pisze w grupie lub w DM do bota (np. „Zbuduj landing page”, „Stwórz repo my-app i otwórz na localhost”, „W repo https://github.com/org/repo dodaj README”). |
| 2 | **Telegram API** | Wiadomość trafia na serwery Telegram. Bot (main lub admin) dostaje ją przez webhook lub long polling. |
| 3 | **OpenClaw gateway** | Proces `openclaw gateway --port 18789` odbiera request od OpenClaw cloud / connector, który rozmawia z Telegramem. Gateway sprawdza, czy kanał to `telegram` i który account (main/admin). |
| 4 | **Bindings** | W `openclaw.json` w tablicy `bindings` jest dopasowanie: `channel: telegram` + `accountId: main` (lub admin) → `agentId: architect`. Wiadomość jest przypisana do agenta **architect**. |
| 5 | **Architect – sesja** | Dla tego wątku (grupa/DM + użytkownik) OpenClaw ładuje lub tworzy sesję agenta **architect**. Ładuje kontekst: workspace (IDENTITY, AGENTS, SOUL), modele, listę skilli (cursor-cloud-agent, create-repo-and-launch, supabase, backend, …). |
| 6 | **Architect – decyzja** | Na podstawie AGENTS.md: pojedyncze zadanie w repo → cursor-cloud-agent; tylko „stwórz repo” → create-repo-and-launch; **build/projekt** → jeśli prompt **trudny** → Cursor (cursor-plan.sh) → plan → subagenci → localhost; jeśli **prosty** → Architect sam planuje (bez Cursor, oszczędność tokenów) → subagenci → localhost. |
| 7a | **Ścieżka: pojedyncze repo** | **exec** `./scripts/cursor-cloud-agent.sh "treść" "https://github.com/..."`. Architect przekazuje użytkownikowi URL Cursora. |
| 7b | **Ścieżka: tylko repo + localhost** | **exec** `./scripts/create-repo-and-launch.sh NAZWA`. Skrypt tworzy repo, scaffold, uruchamia launch-project.sh. Architect potwierdza i podaje localhost. |
| 7c | **Ścieżka: build/projekt** | **Ocena:** prompt trudny → (1) create-repo --no-launch, (2) **exec** cursor-plan.sh (Cursor pisze PLAN.md), (3) parsuj plan, (4) sessions_send z TASK, (5) launch-project.sh. Prompt prosty → (1) create-repo --no-launch, (2) Architect **sam** układa plan (bez Cursor), (3) sessions_send z TASK, (4) launch-project.sh. Na końcu odpowiedź z localhost. |
| 8 | **Baza danych (Supabase)** | Przy zadaniach z bazą Architect zleca agentowi **database** schemat i migracje **Supabase**; backend/frontend dostają instrukcje użycia klienta Supabase. Supabase jest domyślną bazą w stosie (AGENTS.md). |
| 9 | **Odpowiedź** | Architect zwraca do gateway jedną lub więcej wiadomości (tekst, linki, np. URL Cursor, URL localhost). Gateway wysyła je z powrotem na kanał Telegram (ta sama grupa lub DM). |
| 10 | **Telegram** | Użytkownik widzi odpowiedź bota w chacie. |

---

## Gdzie co jest skonfigurowane

| Element | Plik / miejsce |
|--------|-----------------|
| Który agent dostaje wiadomości z Telegrama | `openclaw.json` → `bindings` |
| Tokeny botów Telegram | `openclaw.json` → `channels.telegram.accounts.main/admin.botToken` (oraz .env) |
| Reguły routingu (Cursor vs repo vs agenci) | `workspace-architect/AGENTS.md` |
| Supabase jako domyślna baza | `workspace-architect/AGENTS.md` (sekcja „Wejście i stos”, „Routing rules”, „When given a project”) |
| Skille (Cursor, cursor-plan, create-repo, supabase, …) | `skills/*/SKILL.md`, `openclaw.json` → `skills.entries` |
| Skrypty (Cursor: plan + pojedyncze zadanie, create-repo, launch) | `scripts/cursor-plan.sh`, `scripts/cursor-cloud-agent.sh`, `scripts/create-repo-and-launch.sh`, `websites/launch-project.sh` |

---

## Jak to działa — przykład (build)

Konkretny przebieg, gdy w Telegramie wpiszesz: **„Zbuduj landing page dla kawiarni”**.

| Krok | Kto / co | Działanie |
|------|----------|-----------|
| **1** | Ty (Telegram) | Wpisujesz: „Zbuduj landing page dla kawiarni” i wysyłasz. |
| **2** | Gateway | Odbiera wiadomość, bindings kierują ją do agenta **architect**. |
| **3** | Architect (OpenClaw) | Czyta AGENTS.md: to jest build. Ocena: „landing dla kawiarni” może być uznany za **prosty** (bez Cursor) lub **trudny** (z Cursor). W tym przykładzie zakładamy wariant **z Cursorem**. Wywołuje **exec**: `./scripts/create-repo-and-launch.sh coffee-shop --no-launch` |
| **4** | Skrypt | Tworzy repo na GitHubie (np. `user/coffee-shop`), klonuje do `~/websites/coffee-shop`, robi scaffold Next.js. Nie uruchamia jeszcze localhost. |
| **5** | Architect | Wywołuje **exec**: `./scripts/cursor-plan.sh "Zbuduj landing page dla kawiarni" "https://github.com/TWOJ_USER/coffee-shop"` |
| **6** | cursor-plan.sh | Wysyła do **Cursor Cloud API** prompt: „You are the PROJECT ARCHITECT. Break down: Zbuduj landing page dla kawiarni. Create PLAN.md with detailed TASK for each agent.” |
| **7** | Cursor (chmura) | Działa w repo: pisze **PLAN.md** z sekcjami PROJECT_NAME, TECH_STACK, ui-designer, frontend, backend, database, seo, reviewer — każdy z blokiem TASK (2–5 zdań). Push do repo. |
| **8** | cursor-plan.sh | Czeka (poll co 30 s), aż Cursor skończy. Pobiera PLAN.md (artifacts lub konwersację) i **wypisuje na stdout**. |
| **9** | Architect | Dostaje wynik exec (treść planu). **Parsuje**: PROJECT_NAME = coffee-shop, TASK dla ui-designer, frontend, backend, database, seo, reviewer. |
| **10** | Architect | Wysyła **sessions_send** do **ui-designer** z treścią: „[TASK z planu]. Zapisuj pliki w ~/websites/coffee-shop.” To samo dla frontend, backend, database, seo, reviewer (każdy dostaje swój TASK). |
| **11** | Subagenci (OpenClaw) | Każdy agent wykonuje swój TASK (design, komponenty, API, Supabase, SEO, review) i zapisuje pliki w `~/websites/coffee-shop`. Architect zbiera odpowiedzi przez **sessions_history**. |
| **12** | Architect | Wywołuje **exec**: `./websites/launch-project.sh ~/websites/coffee-shop` |
| **13** | launch-project.sh | `npm install`, `npm run dev`, otwiera przeglądarkę na http://localhost:3000 (lub 3001, 3002…). |
| **14** | Architect | Wysyła do Ciebie w Telegramie: podsumowanie (np. „Landing gotowy. ui-designer, frontend, seo, reviewer. Uruchomiony: http://localhost:3000”). |
| **15** | Ty (Telegram) | Widzisz odpowiedź i możesz otworzyć link w przeglądarce. |

**W skrócie:** Telegram → Architect → create-repo (coffee-shop) → **Cursor pisze PLAN.md** → Architect parsuje plan → wysyła TASK do 6 subagentów → subagenci piszą kod w ~/websites/coffee-shop → launch-project → localhost → odpowiedź w Telegramie.

---

### Inne przykłady

- **„W repo https://github.com/org/repo dodaj README”** → Architect wywołuje tylko `cursor-cloud-agent.sh "Add README" "https://github.com/org/repo"` i odpisuje linkiem do Cursora (bez subagentów, bez localhost).
- **„Stwórz repo my-app i otwórz na localhost”** → Architect wywołuje `create-repo-and-launch.sh my-app` (bez --no-launch) → repo + scaffold + od razu localhost; bez Cursor plan i bez delegacji.

---

## Skrót jednym zdaniem

**Telegram → Gateway → bindings → Architect (OpenClaw) → decyzja (Cursor / create-repo / agenci z Supabase) → exec lub sessions_send → odpowiedź z powrotem przez gateway do Telegrama.**

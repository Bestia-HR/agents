## Antfarm – automatyczne workflowy dla zespołu agentów

Antfarm jest zainstalowany globalnie i zintegrowany z Twoją instancją OpenClaw. Daje on gotowe workflowy multi‑agentowe, które przyspieszają pracę nad repozytoriami oraz zapewniają lepszą kontrolę nad zmianami (śledzenie runów, deterministyczne kroki, weryfikacja przez inne agenty).

- **CLI**: `antfarm`  
- **Dashboard**: `http://localhost:3333` (uruchamia się automatycznie po `antfarm install`, można też włączyć komendą `antfarm dashboard`)

### Dostępne workflowy

Po instalacji masz domyślnie 3 workflowy:

- **feature-dev** – przyjmuje opis funkcji i prowadzi proces od planu, przez implementację i testy, aż po gotowego PR‑a.
- **bug-fix** – przyjmuje opis buga i tworzy łatkę z testem regresyjnym.
- **security-audit** – skanuje repozytorium i przygotowuje PR z poprawkami bezpieczeństwa.

Sprawdź listę:

```bash
antfarm workflow list
```

### Jak używać z projektami stron (`~/websites`)

1. **Wybierz repozytorium** – np. projekt Next.js, który wygenerowały Twoje agenty i który trzymasz w `~/websites/my-site` (lub w innym katalogu z kodem).
2. **Przejdź do repozytorium**:
   ```bash
   cd ~/websites/my-site
   ```
3. **Uruchom workflow rozwoju funkcji**:
   ```bash
   antfarm workflow run feature-dev "Dodaj stronę /pricing z tabelą planów i sekcją FAQ"
   ```
4. **Śledź postęp**:
   ```bash
   antfarm workflow status "pricing"
   antfarm workflow runs
   ```
5. **Przejrzyj wynik** – Antfarm tworzy gałązki/PR‑y (przez `gh` CLI), dzięki czemu masz pełną historię zmian i możesz je ręcznie zaakceptować.

W analogiczny sposób możesz używać:

```bash
antfarm workflow run bug-fix "Napraw błąd: formularz kontaktowy zwraca 500"
antfarm workflow run security-audit "Przeskanuj projekt pod kątem podatności"
```

### Lepsza kontrola nad danymi i zmianami

- **Runy workflowów** są zapisywane w SQLite, możesz zawsze sprawdzić, kto (jaki agent) co zrobił i na jakim kroku jesteś.
- **Kroki są deterministyczne** – zawsze ta sama sekwencja (plan → implementacja → testy → PR), więc łatwiej audytować zmiany.
- **Weryfikacja przez inne agenty** – developer nie „podpisuje” własnego kodu; osobne agenty weryfikują, testują i robią review.

### Przydatne komendy

```bash
antfarm workflow list                # Dostępne workflowy
antfarm workflow runs                # Historia runów
antfarm workflow status <fragment>   # Status runu po fragmencie tytułu
antfarm dashboard                    # Panel webowy na porcie 3333
antfarm uninstall                    # (opcjonalnie) pełne odinstalowanie Antfarm
```


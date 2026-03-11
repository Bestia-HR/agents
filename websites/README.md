# Built websites

- **Save projects to:** `~/websites/[project-name]/` (e.g. `~/websites/coffee-shop/`).
- **Launch a project:** `./launch-project.sh ~/websites/coffee-shop`  
  Installs deps, starts dev server on first free port (3000–3005), opens browser.
- **List projects:** `python3 manager.py list`
- **Start project:** `python3 manager.py start coffee-shop` (runs launch-project.sh)
- **Stop all dev servers:** `python3 manager.py stopall`
- **Delete project:** `python3 manager.py delete coffee-shop`

Port conflict: if port 3000 is busy (e.g. OpenClaw), the script uses 3001, 3002, etc.

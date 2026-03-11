#!/usr/bin/env python3
"""
Manage built websites: list, start, stop.
Usage:
  python3 manager.py list
  python3 manager.py start <project-name>
  python3 manager.py stop <project-name>
  python3 manager.py stopall
  python3 manager.py delete <project-name>
"""
import os
import sys
import subprocess
import json
from pathlib import Path

WEBSITES_ROOT = Path(os.environ.get("WEBSITES_ROOT", Path.home() / "websites"))
SCRIPT_DIR = Path(__file__).resolve().parent
LAUNCH_SCRIPT = SCRIPT_DIR / "launch-project.sh"

def list_projects():
    if not WEBSITES_ROOT.exists():
        print("No websites directory yet:", WEBSITES_ROOT)
        return
    dirs = [d for d in WEBSITES_ROOT.iterdir() if d.is_dir() and not d.name.startswith(".")]
    if not dirs:
        print("No projects in", WEBSITES_ROOT)
        return
    print("Projects in", WEBSITES_ROOT)
    print("-" * 50)
    for d in sorted(dirs, key=lambda x: x.stat().st_mtime, reverse=True):
        has_pkg = (d / "package.json").exists()
        print(f"  {d.name:<30} package.json={'✅' if has_pkg else '❌'}")

def find_free_port():
    for port in range(3000, 3010):
        try:
            import socket
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.bind(("", port))
                return port
        except OSError:
            continue
    return 3010

def start_project(name):
    path = WEBSITES_ROOT / name
    if not path.exists() or not path.is_dir():
        print(f"Project not found: {path}")
        sys.exit(1)
    if not LAUNCH_SCRIPT.exists():
        print("Launch script not found:", LAUNCH_SCRIPT)
        sys.exit(1)
    os.chdir(SCRIPT_DIR)
    subprocess.run(["bash", str(LAUNCH_SCRIPT), str(path)], check=True)

def stop_project(name):
    path = WEBSITES_ROOT / name
    if not path.exists():
        print(f"Project not found: {path}")
        return
    # Find process using this cwd or port (simplified: kill node in project path)
    try:
        result = subprocess.run(
            ["lsof", "-t", f"+D", str(path)], capture_output=True, text=True
        )
        if result.stdout.strip():
            for pid in result.stdout.strip().split():
                os.kill(int(pid), 9)
            print(f"Stopped processes for {name}")
        else:
            print(f"No running process found for {name}. Try: pkill -f '{path}'")
    except Exception as e:
        print("Stop failed:", e)

def stop_all():
    # Kill node processes that are next dev servers (simplified)
    try:
        subprocess.run(["pkill", "-f", "next dev"], capture_output=True)
        print("Stopped all Next.js dev servers (if any were running)")
    except Exception as e:
        print("Stop all failed:", e)

def delete_project(name):
    path = WEBSITES_ROOT / name
    if not path.exists():
        print(f"Project not found: {path}")
        return
    confirm = input(f"Delete {path} and all contents? [y/N] ")
    if confirm.lower() == "y":
        import shutil
        shutil.rmtree(path)
        print(f"Deleted {path}")
    else:
        print("Cancelled")

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(0)
    cmd = sys.argv[1].lower()
    if cmd == "list":
        list_projects()
    elif cmd == "start":
        if len(sys.argv) < 3:
            print("Usage: manager.py start <project-name>")
            sys.exit(1)
        start_project(sys.argv[2])
    elif cmd == "stop":
        if len(sys.argv) < 3:
            print("Usage: manager.py stop <project-name>")
            sys.exit(1)
        stop_project(sys.argv[2])
    elif cmd == "stopall":
        stop_all()
    elif cmd == "delete":
        if len(sys.argv) < 3:
            print("Usage: manager.py delete <project-name>")
            sys.exit(1)
        delete_project(sys.argv[2])
    else:
        print("Unknown command:", cmd)
        print(__doc__)
        sys.exit(1)

if __name__ == "__main__":
    main()

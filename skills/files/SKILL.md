---
name: files
description: Open, read, create, and edit files on the user's device within the agent workspace. Use when the user wants to open a file, read file contents, create a new file, save or write a file, edit an existing file, or work with files on their machine.
---

# Files — Open and create files on device

Use this skill when the user asks to **open**, **read**, **create**, **save**, or **edit** files on their device. You have access to file tools: **read**, **write**, **edit**, **apply_patch**. Use them within the agent’s workspace.

## When to use which tool

- **Open / read a file**: Use the **read** tool with the file path. Use the workspace path (e.g. paths under the agent’s workspace directory). For paths the user gives, resolve relative paths against the workspace.
- **Create a new file**: Use the **write** tool with the full path and content. Creates the file (and parent directories if needed). Overwrites if the file already exists.
- **Edit part of an existing file**: Use **edit** (or **apply_patch** when doing multi-hunk patches) so changes are targeted and safe. Prefer this over full **write** when only a section is changing.
- **Replace a file entirely**: Use **write** when the user clearly wants a new version of the whole file.

## Workspace and paths

- Work inside the **agent workspace** (the configured workspace for this agent). All read/write/edit paths should be under that directory unless the user explicitly asks for another location.
- Use **absolute paths** when calling the tools (e.g. under the workspace root). If the user says “create `notes.txt`” or “open `src/app.js`”, resolve relative to the workspace.
- If the user asks to create or open a file “on my device” or “in my project”, use the workspace as the base. If they give an explicit path outside the workspace, only use it if that’s clearly what they want and your tools are allowed there.

## Before creating or overwriting

- **New file**: Create it with **write**. Say which path you used so the user knows where the file is.
- **Existing file**: Prefer **read** first to see current content, then **edit** or **apply_patch** for partial changes. Use **write** only when replacing the whole file is intended (e.g. “save this as …” or “create a new …”).
- If overwriting might destroy important content and the user didn’t clearly ask for a full replace, prefer **edit** or ask once: “This file already exists. Overwrite entirely or edit in place?”

## Delivering to the user

- After **creating** a file: confirm the path and that it was created (e.g. “Created `workspace/notes.txt`”).
- After **reading** a file: summarize or show the relevant parts; don’t dump long contents unless the user asked for the full file.
- After **editing**: say what you changed (e.g. “Updated the config section in `settings.json`”).

## Checklist before replying

- [ ] Paths are under the agent workspace (or user explicitly asked for another path)
- [ ] Used **read** before editing when the file already exists
- [ ] Used **write** for new files or full replacement, **edit** / **apply_patch** for partial changes
- [ ] Told the user the path of any new or updated file

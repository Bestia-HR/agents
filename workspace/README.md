# Agent workspace

This folder is the agent’s workspace. Files here are loaded as context so the agent can use them when replying.

## Knowledge files (agent uses these when answering)

- **HTML_KNOWLEDGE.md** — HTML (structure, semantics, forms, tables, accessibility).
- **CSS_KNOWLEDGE.md** — CSS (selectors, flexbox, grid, responsive, variables, animations).
- **JAVASCRIPT_KNOWLEDGE.md** — JavaScript (ES6+, DOM, async, modules).
- **REACT_KNOWLEDGE.md** — React (components, hooks, state, context, JSX).
- **TYPESCRIPT_KNOWLEDGE.md** — TypeScript (types, interfaces, generics, React typing).
- **AGENTS.md** — Instructions telling the agent when to use each knowledge file.

## Adding more knowledge

Add other `.md` files and reference them in `AGENTS.md`. Restart the gateway after changing workspace files.

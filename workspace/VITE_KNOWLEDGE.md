# Vite + React knowledge reference for this agent

Use this when working with **Vite** (build tool) and **React + Vite** projects. Learn and use this for creating, running, building, and configuring React Vite apps.

---

## What is Vite

- **Vite** is a fast frontend build tool: dev server with native ESM, HMR, and optimized production builds (Rollup).
- **React + Vite:** Standard stack for modern React apps. Default port **5173**; `npm run dev` starts the dev server, `npm run build` builds for production, `npm run preview` serves the build locally.

---

## Create a React Vite project

- **Create:** `npm create vite@latest my-app -- --template react` or `npm create vite@latest my-app -- --template react-ts` for TypeScript.
- **Install and run:** `cd my-app && npm install && npm run dev`. Opens at `http://localhost:5173` by default.
- **Structure:** `index.html` at root (entry); `src/main.jsx` (or `main.tsx`) mounts the app; `src/App.jsx` and `src/App.css`; `vite.config.js` for config.

---

## Scripts (package.json)

- **dev:** `vite` — start dev server (HMR, default port 5173).
- **build:** `vite build` — output to `dist/`.
- **preview:** `vite preview` — serve the built `dist/` locally (default port 4173).

---

## Config: vite.config.js

- **Root:** `root`, `publicDir` (default `public`), `build.outDir` (default `dist`).
- **Port:** `server: { port: 5173 }` (default is 5173).
- **React plugin:** Use `@vitejs/plugin-react` for JSX, Fast Refresh. In config: `import react from '@vitejs/plugin-react'; export default { plugins: [react()] };`.
- **Aliases:** `resolve.alias` (e.g. `'@': path.resolve(__dirname, './src')`).
- **Env:** `.env` files; expose to client with `import.meta.env.VITE_*` (prefix required for client-side).

---

## File structure (typical)

- `index.html` — entry (script type="module" to `src/main.jsx`).
- `src/main.jsx` — `createRoot`, `render(<App />)`.
- `src/App.jsx` / `App.css` — root component.
- `src/components/` — React components.
- `public/` — static assets (copied as-is).
- `vite.config.js` — Vite config.

---

## Running and opening the app

- **Start dev server:** From project root, run **exec** with `workdir` = project path and `command` = `npm run dev`, **background: true**. Server listens on `http://localhost:5173` (or configured port).
- **Open in user's browser:** Run **exec** with `command` = `open http://localhost:5173` (macOS). See **LOCALHOST_KNOWLEDGE.md** for full steps.

---

## Imports and assets

- **ES modules:** Use `import`/`export`; Vite supports JSX, TypeScript, JSON, CSS, assets out of the box.
- **Assets:** Import images/CSS in components; Vite processes and hashes them. Public assets in `public/` are referenced by path (e.g. `/logo.png`).
- **CSS:** `import './App.css'`; CSS Modules, preprocessors (e.g. Sass) need corresponding npm packages.

---

## React + Vite specifics

- **JSX:** No extra config with `@vitejs/plugin-react`; use `.jsx`/`.tsx` extensions.
- **Fast Refresh:** Plugin enables HMR for React components without full reload.
- **Build:** React code is bundled and tree-shaken; production build is in `dist/` (static files to deploy).

When answering Vite or React-Vite questions, use this reference and **REACT_KNOWLEDGE.md** together. For opening/running the app on localhost, use **LOCALHOST_KNOWLEDGE.md**.

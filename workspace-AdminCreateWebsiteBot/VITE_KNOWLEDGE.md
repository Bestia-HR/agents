# Vite + React knowledge reference for this agent

Use this when working with **Vite** and **React + Vite** projects. Learn and use this for creating, running, building, and configuring React Vite apps.

---

## What is Vite

- **Vite:** Fast frontend build tool; dev server with ESM and HMR; production builds via Rollup. **React + Vite:** default port **5173**; `npm run dev`, `npm run build`, `npm run preview`.

---

## Create a React Vite project

- `npm create vite@latest my-app -- --template react` (or `react-ts`). Then `cd my-app && npm install && npm run dev`. App at `http://localhost:5173`.

---

## Scripts and config

- **Scripts:** `dev` → `vite` (port 5173); `build` → `vite build` (output `dist/`); `preview` → `vite preview` (serve build, often port 4173).
- **vite.config.js:** Use `@vitejs/plugin-react` for JSX/Fast Refresh: `plugins: [react()]`. Set `server.port` if needed. Env: `import.meta.env.VITE_*` for client.

---

## Running and opening the app

- Start dev server: **exec** with `workdir` = project root, `command` = `npm run dev`, **background: true**. Open in browser: **exec** with `command` = `open http://localhost:5173`. See **LOCALHOST_KNOWLEDGE.md**.

---

## File structure and imports

- `index.html` → `src/main.jsx` (createRoot, render App). `src/App.jsx`, `src/components/`, `public/` for static assets. Import CSS and assets in components; Vite processes them.

Use **REACT_KNOWLEDGE.md** for React; **LOCALHOST_KNOWLEDGE.md** for opening the app on localhost.

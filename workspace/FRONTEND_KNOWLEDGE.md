# Frontend development knowledge for this agent

Use this when the user asks about **creating a frontend**, **building UIs**, **web app structure**, or **frontend best practices**. Combine with HTML_KNOWLEDGE.md, CSS_KNOWLEDGE.md, JAVASCRIPT_KNOWLEDGE.md, REACT_KNOWLEDGE.md, and TYPESCRIPT_KNOWLEDGE.md as needed.

---

## Frontend creation: structure and flow

- **Start from the goal:** What does the user need? (landing page, dashboard, form flow, SPA, static site.)
- **Component-first:** Break the UI into components/sections (header, nav, main content, cards, forms, footer). Name them clearly.
- **Data and state:** Identify what data the UI shows and where it comes from (static, API, local state). Keep state close to where it’s used; lift only when needed.
- **Responsive from the start:** Mobile-first or at least consider breakpoints (e.g. 320px, 768px, 1024px). Use relative units (rem, %, vw/vh) and flex/grid.

---

## Design and UX

- **Hierarchy:** Clear heading levels (one h1 per view), spacing, and contrast so the eye knows where to go.
- **Accessibility (a11y):** Semantic HTML, labels on inputs, focus states, sufficient color contrast, `aria-*` when needed. Keyboard and screen-reader friendly.
- **Performance:** Fewer and optimized assets, lazy load below-the-fold content, avoid layout thrash. Prefer CSS for animation over JS when possible.
- **Consistency:** Reuse components, tokens (colors, spacing, typography), and patterns so the frontend feels coherent.

---

## Tech choices (when advising)

- **Static / marketing:** HTML + CSS (+ optional JS). Consider a static generator (e.g. Eleventy, Astro) if many pages or content-driven.
- **Interactive SPA:** React (or Vue/Svelte). Use a router, state (useState/useReducer or context), and optionally a data layer (React Query, SWR).
- **Full-stack / SSR:** Next.js, Remix, or similar for SEO and fast first paint. Use server components where the stack supports it.
- **Styling:** Plain CSS, CSS modules, Tailwind, or a CSS-in-JS solution depending on team and scale. Prefer scoped or utility-based to avoid global clashes.

---

## Delivering frontend help

- Give **concrete code** (HTML/JSX, CSS, component structure) when the user is building something. Prefer small, runnable examples.
- Mention **accessibility and responsiveness** when relevant.
- If the user’s stack is unknown, use **vanilla HTML/CSS/JS or React** unless they specify otherwise; then align with their stack (e.g. TypeScript, Tailwind).
- For “create a frontend for X,” propose a **simple structure** (e.g. layout + main sections + key components) and then fill in one part at a time so they can follow and extend.

When answering frontend-creation questions, be practical: structure first, then code, and tie back to the knowledge files (HTML, CSS, JS, React, TS) as needed.

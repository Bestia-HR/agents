---
name: website
description: Improves frontend and website coding—HTML, CSS, JavaScript, and React. Use when building or editing web pages, frontends, landing pages, personal sites, components, or when the user asks about frontend code, layout, styling, or responsive design.
---

# Website — Frontend coding

Use this skill when building or improving websites and frontends. Deliver **complete, runnable** code; prefer **read before edit** on existing files.

## Structure and semantics

- Prefer **semantic HTML**: `<header>`, `<main>`, `<nav>`, `<section>`, `<article>`, `<footer>`, `<h1>`–`<h6>` in order.
- One `<h1>` per page; headings in logical order (no skipped levels).
- Use `<button>` for actions, `<a>` for navigation; avoid div/span for clickable UI when semantics apply.
- Landmarks and headings support accessibility and SEO.

## Layout and styling

- **Mobile-first**: base styles for small screens, then `min-width` media queries for larger breakpoints.
- Use **CSS custom properties** for colors, spacing, and fonts so themes and tweaks stay in one place.
- Prefer **Flexbox** for 1D layout (rows/columns), **Grid** for 2D (cards, galleries).
- Avoid inline styles for structure; use classes and a small, clear CSS file or scoped styles.

## Responsive and UX

- **Viewport meta**: `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- Touch targets at least ~44×44px; spacing between interactive elements.
- Test at 320px, 768px, and 1024px+ if you can; mention breakpoints in your reply when relevant.

## When to use what

- **Static content / landing / portfolio**: HTML + CSS (one or a few files). No build step; runnable by opening the file or with a simple static server.
- **Interactivity (forms, tabs, simple state)**: Vanilla JS or a small script; keep the DOM updates minimal and clear.
- **Multi-page or component-heavy app**: React (or similar) with clear component boundaries; prefer function components and hooks.

## Code quality

- **Read existing files** before editing (especially CSS and JS) so changes don’t break current behavior.
- Prefer **relative units** (rem, em, %) for type and spacing; use px only when necessary (e.g. borders).
- Keep **selectors simple** (e.g. class-based); avoid deep or fragile selector chains.
- If you add JS, use **clear names** and small functions; avoid global namespace pollution.

## Delivering to the user

- Provide **full code** for the requested page or component so the user can run it locally.
- If the project already has a structure (e.g. `index.html` + `styles.css`), match it and say which files you changed.
- For new one-off pages, a single HTML file with `<style>` (and optional `<script>`) is fine unless the user asks for separate files.

## Checklist before replying

- [ ] Valid, semantic structure and one `<h1>`
- [ ] Viewport meta and mobile-friendly base styles
- [ ] Colors/spacing via CSS variables where it helps
- [ ] No obvious a11y issues (focus, contrast, button vs link)
- [ ] Code is complete and runnable (user can open or serve and see the result)

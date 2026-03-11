# Modern animated website templates (for AI agents)

Use these when users ask for modern, animated website designs or landing pages. They are referenced from popular GitHub repos and/or available locally in this project.

---

## 1. Local template: RobotAI 3D animated (in this repo)

**Path:** `templates/robotai-3d-animated/` (project root)

- **Source:** [AHMAD-JX/RobotAI-3DAnimated-Website-Template](https://github.com/AHMAD-JX/RobotAI-3DAnimated-Website-Template)
- **Stack:** HTML5, CSS3 (SCSS), JavaScript (ES6+), **GSAP**, **Three.js**
- **Features:** 3D animations, responsive, futuristic UI, no build step — open `index.html` in a browser.
- **Use when:** User wants a full, runnable animated site with 3D effects. You can read and adapt `index.html` and files under `assets/` (styles, scripts, images). Suggest copying the template folder or key parts into the user’s project and customizing text/assets.

---

## 2. Most popular GitHub: Animata (animation components)

**Source:** [codse/animata](https://github.com/codse/animata) — **~2,400+ stars**, very popular.

- **What it is:** Copy-paste animation and interaction components (not a full page template). Built with **React**, **TailwindCSS**, optional **Framer Motion** and **Lucide**.
- **Use when:** User wants modern animated UI pieces (buttons, cards, scroll effects, etc.) or is already using React/Tailwind. Point them to the repo; they copy components from the repo or from [animata.design](https://animata.design). You can describe patterns (e.g. “use their magnetic button or gradient card”) and link to the repo.
- **License:** MIT.

---

## How to use in Macbotd / agent replies

- For a **full animated website** (HTML/CSS/JS, 3D): use or adapt the **RobotAI** template in `templates/robotai-3d-animated/`. Read its `index.html` and assets to generate similar structure and suggest edits.
- For **animated components** or **React/Tailwind** projects: reference **Animata** (GitHub link above) and suggest copying the needed components from the repo or animata.design.
- When sharing code: keep it runnable (e.g. one HTML file or clear instructions). For RobotAI-based replies, you can inline simplified snippets or point to the local template path so the user can open it.

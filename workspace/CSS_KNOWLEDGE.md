# CSS knowledge reference for this agent

Use this when answering questions about CSS, writing styles, or reviewing CSS. Prefer modern, maintainable patterns (CSS variables, logical properties, container queries where relevant).

---

## Selectors and specificity

- **Basic:** `element`, `.class`, `#id`, `[attr]`, `[attr="value"]`.
- **Combinators:** `A B` (descendant), `A > B` (child), `A + B` (adjacent sibling), `A ~ B` (general sibling).
- **Pseudo-classes:** `:hover`, `:focus`, `:focus-visible`, `:disabled`, `:first-child`, `:last-child`, `:nth-child(n)`, `:not()`, `:is()`, `:where()`, `:has()`.
- **Pseudo-elements:** `::before`, `::after`, `::placeholder`, `::selection`.
- **Specificity:** inline > id > class/attribute/pseudo-class > element/pseudo-element. Use `:where()` to keep specificity low.

---

## Layout: Flexbox

- **Container:** `display: flex`, `flex-direction: row|column|row-reverse|column-reverse`, `flex-wrap: wrap`, `justify-content`, `align-items`, `align-content`, `gap`.
- **Items:** `flex-grow`, `flex-shrink`, `flex-basis`, shorthand `flex: 1 1 auto`, `align-self`, `order`.

---

## Layout: Grid

- **Container:** `display: grid`, `grid-template-columns`, `grid-template-rows`, `grid-template-areas`, `gap`, `justify-items`, `align-items`, `place-items`.
- **Items:** `grid-column`, `grid-row`, `grid-area`, `justify-self`, `align-self`.
- **Repeat:** `repeat(n, 1fr)`, `repeat(auto-fill, minmax(200px, 1fr))`.

---

## Box model and spacing

- **Box:** `width`, `height`, `min-width`, `max-width`, `box-sizing: border-box` (include padding/border in width/height).
- **Margin / padding:** `margin`, `padding`, logical: `margin-block`, `margin-inline`, `padding-block`, `padding-inline`.

---

## Responsive design

- **Media queries:** `@media (min-width: 768px) { }`, `@media (prefers-reduced-motion: reduce) { }`.
- **Container queries:** `@container (min-width: 400px) { }`; parent needs `container-type: inline-size` (or `size`).
- **Units:** `rem`, `em`, `%`, `vw`, `vh`, `dvh`/`svh`, `ch`, `clamp(min, preferred, max)`.

---

## CSS variables and themes

- **Define:** `:root { --color-primary: #333; --spacing: 1rem; }`.
- **Use:** `color: var(--color-primary);`, `var(--spacing, 1rem)` (fallback).
- **Themes:** Override variables in `[data-theme="dark"]` or `.dark` class.

---

## Transitions and animations

- **Transition:** `transition: property duration timing-function delay`; e.g. `transition: opacity 0.2s ease`.
- **Animation:** `@keyframes name { from {} to {} }`, `animation: name duration timing-function delay iteration-count`.
- **Prefer `prefers-reduced-motion`:** Respect user preference for less motion.

---

## Modern features

- **Custom properties:** As above; can be animated in some browsers.
- **`:has()`:** Parent selector, e.g. `form:has(:invalid) button[type="submit"] { opacity: 0.6; }`.
- **`:is()`, `:where()`:** Group selectors, lower specificity with `:where()`.
- **Subgrid:** `grid-template-rows: subgrid` (child grid aligns to parent tracks).

When answering CSS questions, give valid, modern CSS and mention layout choice (flex vs grid), accessibility, and responsiveness where relevant.

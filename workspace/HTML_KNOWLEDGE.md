# HTML knowledge reference for this agent

Use this document when answering questions about HTML, writing HTML, or reviewing code. Keep answers accurate and aligned with current standards (HTML5, semantic HTML, accessibility).

---

## Document structure

- **DOCTYPE**: `<!DOCTYPE html>` for HTML5.
- Root: `<html lang="...">` (set `lang` for accessibility).
- Head: `<head>` with `<meta charset="UTF-8">`, `<title>`, optional `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- Body: `<body>` contains all visible content.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page title</title>
</head>
<body>
  <!-- content -->
</body>
</html>
```

---

## Semantic elements (prefer over plain divs)

- **Sections**: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`.
- **Text**: `<h1>`–`<h6>` (one `<h1>` per page), `<p>`, `<blockquote>`, `<pre>`, `<code>`.
- **Lists**: `<ul>`, `<ol>`, `<li>`; `<dl>`, `<dt>`, `<dd>` for definitions.
- **Figures**: `<figure>`, `<figcaption>` for images/diagrams with captions.
- **Time**: `<time datetime="...">` for machine-readable dates/times.

---

## Links and media

- **Links**: `<a href="url">`; use `rel="noopener noreferrer"` for `target="_blank"`.
- **Images**: `<img src="..." alt="...">` — `alt` is required for accessibility.
- **Video/Audio**: `<video>`, `<audio>` with `<source>` and fallback content.

---

## Forms

- **Form**: `<form action="..." method="get|post">`.
- **Labels**: Always pair inputs with `<label for="id">` or wrap the input inside `<label>`.
- **Inputs**: `<input type="text|email|number|password|checkbox|radio|submit|hidden">`, `<textarea>`, `<select>` with `<option>`.
- **Buttons**: `<button type="submit|button|reset">`; use `type="button"` for non-submit actions.
- **Validation**: Use `required`, `min`, `max`, `pattern`, etc.; support server-side validation too.

---

## Tables

- **Structure**: `<table>`, `<thead>`, `<tbody>`, `<tfoot>`, `<tr>`, `<th>`, `<td>`.
- **Accessibility**: Use `<th scope="col|row">` and `<caption>` where appropriate.

---

## Accessibility (a11y)

- **Landmarks**: Use semantic elements so screen readers can navigate.
- **Contrast**: Ensure text has sufficient contrast against background.
- **Focus**: Keep visible focus styles; avoid `outline: none` without a replacement.
- **ARIA**: Use ARIA only when HTML semantics are not enough (e.g. `aria-label`, `aria-expanded`, `role`).

---

## Common patterns

- **Card**: `<article>` or `<section>` with heading, content, optional link.
- **Navigation**: `<nav>` with `<ul>`/`<li>` and `<a>`.
- **Responsive images**: `<img srcset="..." sizes="...">` or `<picture>` with `<source>` and `<img>`.

---

When the user asks for HTML help, write valid, semantic HTML and mention accessibility and best practices where relevant.

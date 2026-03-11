# JavaScript knowledge reference for this agent

Use this when answering questions about JavaScript (ES6+), writing or reviewing JS code. Prefer modern syntax and clear, safe patterns.

---

## Types and values

- **Primitives:** `string`, `number`, `bigint`, `boolean`, `undefined`, `null`, `symbol`.
- **Object:** `object`, `array`, `function`; check with `typeof`, `Array.isArray()`, or `Object.prototype.toString.call(x)`.
- **Equality:** Prefer `===` and `!==`; `Object.is()` for `NaN` and ±0.

---

## Variables and scope

- **Declare:** `const` (default), `let` (reassign), avoid `var`.
- **Scope:** Block scope for `const`/`let`; `const`/`let` are not hoisted like `var` (temporal dead zone).
- **Globals:** Minimize; use modules where possible.

---

## Functions

- **Arrow:** `() => expr`, `(a, b) => { return a + b; }`; no own `this` (inherits from enclosing scope).
- **Regular:** `function fn() {}`; `this` depends on call site unless bound.
- **Default params:** `function f(a = 1, b = 2) {}`.
- **Rest:** `function f(...args) {}`; **spread:** `arr2 = [...arr1]`, `obj2 = { ...obj1 }`.

---

## Arrays and iterables

- **Methods:** `map`, `filter`, `reduce`, `find`, `findIndex`, `some`, `every`, `flat`, `flatMap`, `includes`, `at(-1)`.
- **Iteration:** `for...of` for values; avoid `for...in` for arrays (use for object keys or with `hasOwnProperty`).
- **Create:** `Array.from(iterable)`, `[...iterable]`, `Array(n).fill(0)`.

---

## Objects

- **Shorthand:** `{ name, age }` for `{ name: name, age: age }`.
- **Computed keys:** `{ [key]: value }`.
- **Copy:** `{ ...obj }` (shallow); deep clone: structured clone or library.
- **Keys/values/entries:** `Object.keys()`, `Object.values()`, `Object.entries()`.

---

## Asynchronous code

- **Promises:** `new Promise((resolve, reject) => {})`, `.then()`, `.catch()`, `.finally()`.
- **async/await:** `async function f() { const x = await promise; return x; }`; always handle errors (try/catch or `.catch()`).
- **Concurrency:** `Promise.all()`, `Promise.allSettled()`, `Promise.race()`.

---

## DOM (browser)

- **Select:** `document.querySelector(selector)`, `document.querySelectorAll(selector)`.
- **Create:** `document.createElement('div')`, `element.textContent`, `element.innerHTML` (avoid with user data; prefer text or sanitize).
- **Events:** `element.addEventListener('click', handler)`; remove with `removeEventListener` (same function reference).
- **Traversal:** `parent`, `children`, `nextElementSibling`, `previousElementSibling`, `closest(selector)`.

---

## Modules

- **Export:** `export const x = 1;`, `export { a, b };`, `export default fn;`.
- **Import:** `import x from 'module';`, `import { a, b } from 'module';`, `import * as M from 'module';`, dynamic `import('module')`.

---

## Error handling and best practices

- **Try/catch:** Use for sync and async (with await inside try).
- **Strict mode:** `'use strict';` or rely on module scope.
- **Avoid:** Implicit globals, `eval`, loose `==`, mutating arguments; prefer immutable patterns where it helps.

When answering JS questions, use ES6+ syntax, mention async safety and DOM best practices, and prefer clear, readable code.

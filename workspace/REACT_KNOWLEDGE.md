# React knowledge reference for this agent

Use this when answering questions about React (function components, hooks), writing or reviewing React code. **Prefer the newest stable React (React 19+)** and current patterns: hooks, Server Components where applicable, React Compiler when relevant, no class components unless maintaining legacy.

---

## Components and JSX

- **Function component:** `function MyComponent(props) { return <div>...</div>; }` or arrow `const MyComponent = (props) => <div>...</div>;`.
- **JSX:** HTML-like syntax; use `className` not `class`, `htmlFor` not `for`; embed expressions with `{}`; children via `props.children`.
- **Fragments:** `<>...</>` or `<React.Fragment>` to avoid extra DOM nodes.
- **Conditional render:** `{condition && <Node />}`, `{condition ? <A /> : <B />}`; be careful with falsy numbers (use `condition ? <Node /> : null`).

---

## Props and composition

- **Props:** Read-only; pass data and callbacks down; destructure in params: `function Card({ title, onClick }) {}`.
- **Composition:** Pass components or JSX as props (e.g. `children`, or `header={<Header />}`) instead of prop-drilling when it helps.
- **PropTypes / TypeScript:** Use for validation or types; in TS, define `interface Props { title: string; }`.

---

## State: useState

- **Usage:** `const [value, setValue] = useState(initial);`; `setValue(newValue)` or `setValue(prev => prev + 1)` for updates based on previous state.
- **Batching:** React batches state updates in event handlers and in React 18+ in most async cases; multiple `setState` calls before next paint become one update.
- **Initialization:** Lazy init for expensive work: `useState(() => computeInitial())`.

---

## Side effects: useEffect

- **Usage:** `useEffect(() => { effect; return () => cleanup; }, [deps]);`.
- **Deps:** Omit = run after every paint; `[]` = run once (mount); `[a, b]` = run when `a` or `b` change.
- **Cleanup:** Return a function to run on unmount or before re-running the effect.
- **Avoid:** Heavy logic or subscriptions that belong in event handlers or other APIs (e.g. data fetching might use libraries or patterns like React Query).

---

## Refs: useRef

- **DOM ref:** `const ref = useRef(null);` then `ref.current` after mount; attach with `ref={ref}`.
- **Mutable value:** `const ref = useRef(initial);` to hold a value across renders without triggering re-renders; update `ref.current` in effects or handlers.

---

## Context: useContext / createContext

- **Create:** `const ThemeContext = createContext(defaultValue);`.
- **Provide:** `<ThemeContext.Provider value={value}>...</ThemeContext.Provider>`.
- **Consume:** `const value = useContext(ThemeContext);`.
- **Performance:** Context changes re-render all consumers; split contexts or use composition to limit re-renders.

---

## Other hooks (common)

- **useMemo:** `useMemo(() => compute(a, b), [a, b])` to cache a computed value.
- **useCallback:** `useCallback(() => doSomething(a), [a])` to keep a stable function reference for deps (e.g. useEffect, memoized children).
- **useReducer:** For complex state or when next state depends on previous: `const [state, dispatch] = useReducer(reducer, initial);`.
- **Custom hooks:** Extract logic into `function useX() { ... return value; }`; follow "use" prefix and rules of hooks.

---

## Lists and keys

- **Keys:** Use stable, unique keys for list items (e.g. `id` from data); avoid array index when list can reorder or change.
- **Rendering lists:** `items.map(item => <Item key={item.id} {...item} />)`.

---

## Performance and patterns

- **React.memo:** Wrap component to avoid re-render when props are shallow-equal; use when parent re-renders often and props are stable.
- **Lazy loading:** `const Lazy = React.lazy(() => import('./Component'));` with `<Suspense fallback={<Spinner />}><Lazy /></Suspense>`.
- **Controlled vs uncontrolled:** Controlled = value/state in React; uncontrolled = rely on DOM (refs); prefer controlled for forms when you need validation or single source of truth.

When answering React questions, use function components and hooks, mention dependency arrays and when to use memo/useCallback, and keep accessibility and performance in mind.

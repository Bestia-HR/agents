# TypeScript knowledge reference for this agent

Use this when answering questions about TypeScript, typing React/JS code, or reviewing TS. Prefer clear, accurate types and modern TS features.

---

## Basic types

- **Primitives:** `string`, `number`, `boolean`, `null`, `undefined`, `symbol`, `bigint`.
- **Arrays:** `string[]` or `Array<string>`; tuples: `[string, number]`.
- **Any:** `any` (opt-out of checking); avoid when possible; prefer `unknown` for truly unknown values.
- **Unknown:** `unknown` — must narrow (type guards, `typeof`, assertions) before use.
- **Void / never:** `void` for no return; `never` for unreachable (e.g. throw, exhaustive switch).

---

## Interfaces and types

- **Interface:** `interface User { id: number; name: string; optional?: string; readonly id: number; }`.
- **Type alias:** `type Point = { x: number; y: number };`; can express unions, primitives, tuples.
- **Extend:** `interface B extends A { }`; types: `type B = A & { extra: string };`.
- **Index signature:** `interface Dict { [key: string]: number; }`.

---

## Unions and narrowing

- **Union:** `string | number`; `type Status = 'idle' | 'loading' | 'error';`.
- **Narrowing:** `if (typeof x === 'string') { ... }`, `if ('id' in obj)`, discriminated unions with a common literal field.
- **Type guard:** `function isString(x: unknown): x is string { return typeof x === 'string'; }`.
- **Assertion:** `value as Type` or `value as unknown as Type` (double when crossing incompatible types); use sparingly.

---

## Generics

- **Functions:** `function identity<T>(x: T): T { return x; }`.
- **Interfaces/types:** `interface Box<T> { value: T; }`; `type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };`.
- **Constraints:** `function first<T extends { length: number }>(arr: T): T[0] { return arr[0]; }`.
- **Default:** `interface Props<T = string> { value: T; }`.

---

## Utility types

- **Partial<T>:** All properties optional.
- **Required<T>:** All properties required.
- **Readonly<T>:** All properties readonly.
- **Pick<T, K>:** Subset of keys: `Pick<User, 'id' | 'name'>`.
- **Omit<T, K>:** Exclude keys: `Omit<User, 'password'>`.
- **Record<K, V>:** Object type: `Record<string, number>`.
- **ReturnType<F>:** Return type of function.
- **Parameters<F>:** Tuple of function parameters.

---

## Functions and callbacks

- **Signatures:** `(x: string) => number`, `(a: number, b?: number) => void`.
- **Void return:** Use `void` when callback return is ignored: `onClick: () => void`.
- **Generics:** `function map<T, U>(arr: T[], fn: (x: T) => U): U[] { return arr.map(fn); }`.

---

## React with TypeScript

- **Props:** `interface ButtonProps { label: string; onClick: () => void; }` then `const Button: React.FC<ButtonProps> = ({ label, onClick }) => ...` or `function Button({ label, onClick }: ButtonProps) {}`.
- **Children:** `React.ReactNode` for `children`.
- **Events:** `React.ChangeEvent<HTMLInputElement>`, `React.MouseEvent<HTMLButtonElement>`.
- **Refs:** `useRef<HTMLInputElement>(null)`; `ref.current` can be `null` until attached.
- **State:** `useState<number>(0)`; infer when possible.

---

## Modules and declaration

- **Export/import types:** `export type { User };`, `import type { User } from './types';`.
- **Declaration files:** `*.d.ts` for ambient types; `declare module 'lib' { ... }` for untyped modules.
- **Global augment:** `declare global { interface Window { myApp: App; } }`.

---

## Strictness and best practices

- **Strict mode:** Enable `strict` (and related options) in `tsconfig.json`.
- **Avoid:** `any` when a proper type or `unknown` + narrowing is possible; non-null assertion (`!`) without certainty; casting away errors instead of fixing types.
- **Prefer:** Explicit return types on public APIs; shared types in a `types` module; union types and narrowing over type assertions.

When answering TypeScript questions, give correct, idiomatic types and mention strictness, generics, and React typing patterns where relevant.

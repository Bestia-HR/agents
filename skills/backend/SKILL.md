---
name: backend
description: Improves backend and server-side coding—APIs, databases, auth, and services. Use when building or editing APIs, server logic, database schemas, auth, env/config, or when the user asks about backend code, endpoints, or data handling.
---

# Backend — Server-side coding

Use this skill when building or improving backends and APIs. Deliver **complete, runnable** code; prefer **read before edit** on existing files.

## Structure and layers

- Keep **handlers/routes** thin: validate input, call service layer, return response. No business logic in route files.
- Put **business logic** in services or modules that don’t depend on HTTP (easier to test and reuse).
- **Config** (ports, DB URLs, API keys) from environment variables or a single config module; never hardcode secrets.
- Use a clear **project layout** (e.g. `routes/`, `services/`, `models/`, `config/`) so the agent and humans can navigate.

## APIs and HTTP

- **REST**: consistent HTTP methods (GET read, POST create, PUT/PATCH update, DELETE remove) and status codes (200, 201, 400, 401, 404, 500).
- **JSON** for request/response bodies; set `Content-Type: application/json` and handle parse errors.
- **Idempotency**: GET, PUT, DELETE idempotent; POST for new resources. Document when something is not idempotent.
- Prefer **explicit status codes** and a small, stable response shape (e.g. `{ data }` or `{ error: { code, message } }`).

## Validation and errors

- **Validate all inputs** (query, body, params) before use; reject invalid data with 400 and a clear message.
- **Never expose stack traces or internal details** to clients; log them server-side only.
- Use **typed errors** or error codes where useful so clients can handle known cases (e.g. validation vs auth vs not-found).

## Data and persistence

- **Parameterize queries**; never build SQL/NoSQL from raw user input (prevents injection).
- Prefer **migrations** for schema changes; document how to run them.
- When reading existing code, check **existing schema and indexes** before suggesting new tables or columns.

## Security

- **Secrets**: env vars or a secrets manager; never in code or in client-visible responses.
- **Auth**: validate tokens/sessions on protected routes; use standard libraries (e.g. JWT, session middleware) where possible.
- **CORS**: set allowed origins explicitly; don’t use `*` in production for credentialed requests.
- **Rate limiting / timeouts**: consider for public or costly endpoints.

## Code quality

- **Read existing files** (routes, services, models, config) before editing so changes fit the current style and behavior.
- **Error handling**: catch and handle expected cases; log and return safe responses for unexpected errors.
- Prefer **small, focused functions** and clear names; avoid long request-handling blocks.
- If the project has **tests**, add or update them for new or changed behavior.

## Delivering to the user

- Provide **full code** for the requested handler, service, or script so the user can run or integrate it.
- If the project already has a structure (e.g. Express/Fastify routes, Django views), match it and say which files you changed.
- Document **env vars** or config the code expects (e.g. `PORT`, `DATABASE_URL`).
- For new one-off scripts (e.g. a CLI or migration), a single file with a clear entry point is fine unless the user asks for a full app layout.

## Checklist before replying

- [ ] No secrets in code; config from env or config module
- [ ] Inputs validated; invalid input returns 4xx with clear message
- [ ] Queries parameterized; no string concatenation of user input into SQL
- [ ] Errors logged server-side; client gets safe, stable response shape
- [ ] Code is complete and runnable (user can set env and start the server or script)

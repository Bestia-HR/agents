# Prompts to check page-building bots in the Telegram group

Use these prompts in your Telegram group to test that **Agent A** and **Agent B** can build pages and use their skills (delegation, code, web).

---

## 1. Quick check — “Can you build a page?”

**Prompt to send in the group:**

```
Can you build a simple landing page with a headline and a CTA button? Use HTML and a bit of CSS. Show me the code.
```

- **Agent B** (AdminCreateWebsiteBot) may reply directly or delegate to **Agent A** with `sessions_send`.
- **Agent A** (main) should produce HTML/CSS or confirm it can do it.

---

## 2. Check delegation (Agent B → Agent A)

**Prompt:**

```
Ask the other bot to write a one-section “About us” HTML page and paste the result here.
```

- **Agent B** should use `sessions_list` → `sessions_send` to send the task to **Agent A**, then `sessions_history` to get the reply and show it in the group.

---

## 3. Check web + code skills

**Prompt:**

```
Search for “simple HTML5 landing page structure 2024” and then write a minimal example (headline + paragraph + button) based on best practices. Put the code in a code block.
```

- Tests **web_search** (or web fetch) and **write**/code generation. Either bot can answer; Agent B may delegate to Agent A.

---

## 4. Check both bots and collaboration

**Prompt:**

```
I need a small “Contact” section: title, short text, and a fake email. Coordinator bot: delegate this to the builder bot and reply with what it returns.
```

- **Agent B** must delegate to **Agent A** and reply with Agent A’s output.

---

## 5. One-line sanity check

**Prompt:**

```
Build a one-div “Hello World” HTML snippet and send it here.
```

- Quick check that at least one bot can generate HTML.

---

## What to look for

| Check              | Expected behavior |
|--------------------|-------------------|
| **Agent B replies**| Answers in the group, may say it’s delegating to the other bot. |
| **Agent B delegates**| Uses `sessions_send` to Agent A and then posts the result. |
| **Agent A builds**  | Returns HTML/CSS or a file path when asked to build a page. |
| **Web + code**     | Search/fetch works and the bot uses the result in generated code. |

If a bot doesn’t reply, check: gateway running, Telegram bindings, and that the message is in the right group where both bots are added.

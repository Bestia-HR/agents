---
name: web-research
description: Research topics on the internet and fetch data from web pages. Use when the user asks to research something, find information online, fetch a URL, read a webpage, summarize an article, get content from a link, or look up current information.
---

# Web research — Research and fetch data from pages

Use this skill when the user asks to **research** a topic, **find information** online, **fetch a URL**, **read a webpage**, **summarize an article**, **get content from a link**, or **look up current** information. Use **web_search**, **web_fetch**, and **browser** as needed. To **redirect the user** to a page, use **exec** with `open "URL"` or `open -a Safari "URL"`. See **AGENT_TOOLS_KNOWLEDGE.md** section 7 for full good practice.

## Good practice

- **Research flow:** (1) **web_search** with clear, focused queries. (2) For promising URLs, **web_fetch** to get full text; summarize or extract data. (3) If a page is JS-heavy or fetch fails, use **browser** (navigate, then snapshot or screenshot).
- **Redirect when asked:** If the user says “open this in my browser” or “direct me to that page”, run **exec** with `open "https://..."` or `open -a Safari "https://..."` so their browser opens the URL. Don’t only fetch — open for them when they ask.

## Web search

- Use **web_search** with a short, targeted query (e.g. “React 19 release date”, “Supabase edge functions docs”). Use when the user asks for “research”, “find out”, “look up”, “current info”, or “latest on X”.
- Run one or a few queries; then use the results and optionally **web_fetch** on returned URLs for deeper content.

## Fetch a URL (web_fetch)

- Use **web_fetch** when the user gives a **URL** or asks to “fetch this page”, “read this link”, “summarize this article”, or “get content from this site”.
- Pass the **url** and **extractMode** (e.g. `markdown` or `text`) as needed. Use the extracted content to summarize or answer the user.

## Browser tool (when fetch isn’t enough)

- Use **browser** (action **navigate**, then **snapshot** or **screenshot**) when the page is **JavaScript-heavy**, paywalled, or **web_fetch** doesn’t return good content. Slower; use when necessary.

## Redirect the user to a page

- **exec** with **command** = `open "https://the-url.com"` (default browser) or `open -a Safari "https://the-url.com"` (Safari). Use the exact URL the user asked for. Do this when they want to be taken to a page, not only when you fetch it.

## Summary

| Task           | Tool / Command                          |
|----------------|-----------------------------------------|
| Research topic | web_search (targeted queries)           |
| Get page content | web_fetch (url, extractMode)         |
| JS-heavy page  | browser (navigate, snapshot/screenshot) |
| Redirect user  | exec: `open "URL"` or `open -a Safari "URL"` |

Use **AGENT_TOOLS_KNOWLEDGE.md** section 7 for the full flow and good practice.

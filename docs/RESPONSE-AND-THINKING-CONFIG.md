# Where to change response efficiency and thinking in OpenClaw

All of these go in **`openclaw.json`** (or your main OpenClaw config file).

---

## 1. Thinking / reasoning depth

**Config path:** `agents.defaults.thinkingDefault`

**Values:** `"off"` | `"minimal"` | `"low"` | `"medium"` | `"high"` | `"xhigh"`

| Value    | Effect |
|----------|--------|
| `off`    | No extended reasoning; fastest, least “deep” thinking. |
| `minimal`| Very light reasoning. |
| `low`    | “Think hard” – some reasoning. |
| `medium` | “Think harder” – balanced (good default). |
| `high`   | “Ultrathink” – maximum reasoning budget; slower, more thorough. |
| `xhigh`  | “Ultrathink+” – for models that support it (e.g. some GPT/Codex). |

**Example in config:**
```json
"agents": {
  "defaults": {
    "thinkingDefault": "medium"
  }
}
```

- **Faster, less thinking:** `thinkingDefault: "low"` or `"off"`.
- **Slower, more thorough:** `thinkingDefault: "high"`.

You can also override per message in chat (e.g. `/think:high` or your client’s equivalent) if your OpenClaw version supports it.

---

## 2. Response “efficiency” (length and focus)

**Config path:** `agents.defaults.models["<model-id>"].params`

Relevant params:

| Param        | Where                    | Effect |
|-------------|---------------------------|--------|
| **temperature** | `params.temperature`   | 0–2. Lower = more focused and deterministic; higher = more varied. Use ~0.3–0.5 for precise/short, ~0.7–0.9 for creative/longer. |
| **maxTokens**   | `params.maxTokens`     | Max length of the reply. Lower = shorter answers (faster, more “efficient”). |

**Example in config:**
```json
"agents": {
  "defaults": {
    "models": {
      "nvidia/moonshotai/kimi-k2.5": {
        "alias": "Kimi K2.5",
        "params": {
          "temperature": 0.7,
          "maxTokens": 4096
        }
      }
    }
  }
}
```

- **More efficient / shorter:** e.g. `temperature: 0.5`, `maxTokens: 2048`.
- **Richer / longer:** e.g. `temperature: 0.8`, `maxTokens: 8192`.

---

## 3. Summary: where in OpenClaw

| What you want to change      | Where in OpenClaw config |
|-----------------------------|---------------------------|
| How much the agent “thinks” | `agents.defaults.thinkingDefault` |
| How focused vs creative     | `agents.defaults.models["<model-id>"].params.temperature` |
| Max response length         | `agents.defaults.models["<model-id>"].params.maxTokens` (and/or in `models.providers.*.models[].maxTokens`) |

Restart the gateway after editing the config so changes apply.

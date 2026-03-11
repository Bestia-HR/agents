# Why bots respond slowly in Macbotd (and what was changed)

## Causes of slow response

| Cause | What it does |
|-------|----------------|
| **Thinking mode** | With `thinkingDefault: "medium"` or `"high"`, the model does extended reasoning before replying. That can add many seconds (or minutes for complex tasks) before you see any text. |
| **Streaming off** | With `streaming: "off"`, Telegram only shows the reply **after** the full message is generated. You wait for the entire response instead of seeing it appear word by word. |
| **Local Ollama** | The model runs on your Mac. Speed depends on CPU/GPU and RAM. Llama 3.2 is relatively fast; larger models (e.g. 8B+) are slower. |
| **High maxTokens** | Allowing up to 8192 tokens means the model can produce very long answers; the first token still takes the same time, but "done" is later. |

## Changes made to speed things up

1. **thinkingDefault: "off"**  
   The agent no longer does extended "thinking" before replying. You get a direct answer, so latency is lower. For harder tasks you can still ask the bot to "think step by step" in the message.

2. **streaming: "partial"** for both Telegram bots (main and admin)  
   Replies are sent to the chat **as they are generated**, so you see text quickly instead of waiting for the full message.

Restart the gateway after config changes: stop it (Ctrl+C), then run `./run-gateway.sh` again.

## If it’s still slow

- **Ollama**: Use a smaller/faster model (e.g. `llama3.2` 3B if you have it) or ensure Ollama is using GPU (Metal on Mac) if available.
- **Heavy tasks**: For coding or long answers, the model simply needs more time. Streaming at least makes the start of the reply appear sooner.
- **Thinking for hard questions**: If you need deeper reasoning for one message, you can say in the message: “think step by step” or “take your time and reason”; the model can still do more reasoning in the reply itself.

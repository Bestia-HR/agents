# Prompt: Personal website (yellow & black)

Send this in the **Macbotd** Telegram group (or to the bots) to have them create a personal website with yellow and black as the main colors.

---

## Copy-paste prompt

```
Task for all bots: Create a personal website for me. Use yellow and black as the main colors. Include: a hero section with my name/tagline, a short about section, a skills or services section, and a contact section. Prefer clean, modern layout. Use HTML and CSS (or React if you prefer). Show me the full code so I can run it locally.
```

---

## Shorter version

```
Create a personal website. Main colors: yellow and black. Hero, about, skills, contact. Full HTML/CSS or React code.
```

---

## If you want to trigger from the project

To send this to the Macbotd group so the bots process it and reply there (gateway must be running):

```bash
cd /Users/user/agent
export OPENCLAW_CONFIG_PATH="$(pwd)/openclaw.json" OPENCLAW_STATE_DIR="$(pwd)/.openclaw-state"
[[ -f .env ]] && set -a && . ./.env && set +a

# Post the prompt in the group (so you or the bots see it)
openclaw message send --channel telegram --target -5049131940 --message "Task for all bots: Create a personal website for me. Use yellow and black as the main colors. Include: hero with name/tagline, about, skills, contact. Clean modern layout. Full HTML/CSS or React code." --account main
```

Then ask in the group (e.g. “do it” or “send the code”) and the bots will generate the site.

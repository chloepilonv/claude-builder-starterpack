---
name: design
description: Jump to Phase 7 — Frontend Design. Pass a style direction as argument. Examples — /design pink barbie | /design dark brutalist terminal | /design clean swiss fintech | /design "moodboard: early iPod UI, white plastic, chrome, soft gradients"
disable-model-invocation: false
---

# App Builder — Phase 7: Frontend Design

Invoke the `design-agent` subagent with the style direction from `$ARGUMENTS`.

**Usage examples:**
```
/design pink barbie
/design dark brutalist terminal
/design clean swiss fintech
/design luxury editorial magazine
/design sci-fi data dashboard
/design moodboard: ./refs/brand1.png ./refs/brand2.png
/design moodboard: think early Winamp, dark gradients, neon, chrome
```

If `$ARGUMENTS` is empty, `design-agent` will ask the user for a direction before proceeding. Never design without a direction.

Require that `.app-builder/frontend-basic.md` exists (Phase 6 must be done).

Pass the style direction and the frontend-basic artifact path to design-agent.

After completion, update `.app-builder/state.json` to mark Phase 7 as done.

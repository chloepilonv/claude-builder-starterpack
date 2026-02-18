---
name: frontend
description: Jump to Phase 6 — Frontend Basic App. Builds the functional UI before design polish.
disable-model-invocation: false
---

# App Builder — Phase 6: Frontend Basic

Invoke the `frontend-agent` subagent to build the basic functional frontend.

Require that at least `.app-builder/build-p1.md` exists (MVP Phase 1 must be done).

If the backend isn't ready, the agent will use mock data and flag the dependencies.

Pass spec, plan, and any `$ARGUMENTS` to the frontend agent.

After completion, update `.app-builder/state.json` to mark Phase 6 as done.

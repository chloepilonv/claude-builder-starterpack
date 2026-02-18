---
name: build
description: Execute an MVP build phase. Usage — /build 1 | /build 2 | /build 3 | /build 4. Phase goals are defined in the plan, not assumed. Can handle more than 3 phases if the plan defines them.
disable-model-invocation: false
---

# App Builder — MVP Build Phase

Invoke the `build-agent` subagent for the MVP phase specified in `$ARGUMENTS`.

Valid values: any phase number that exists in `.app-builder/plan.md` (e.g. `1`, `2`, `3`, `4`...).

**The phase goal, tasks, and success criteria come from the plan — not from any default assumption about what "Phase 1" or "Phase 2" means.**

If no argument provided, check `.app-builder/state.json` and execute the next incomplete MVP phase.

Require that `.app-builder/plan.md` exists. If not: "No plan found. Please run /plan first."

If the phase requires Nebius or other cloud infrastructure, coordinate with `nebius-agent` via the `/nebius` skill.

After completion, update `.app-builder/state.json` to mark the phase done.

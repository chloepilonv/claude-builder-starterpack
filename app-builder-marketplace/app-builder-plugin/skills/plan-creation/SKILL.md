---
name: plan
description: Jump directly to Phase 2 — Plan Creation & Validation. Creates a phased execution plan from the spec.
disable-model-invocation: false
---

# App Builder — Phase 2: Plan Creation & Validation

Invoke the `plan-agent` subagent to create and validate the development plan.

Require that `.app-builder/spec.md` exists. If it doesn't, say:
"No spec found. Please run /spec first (Phase 1) before creating a plan."

Pass the spec content and any `$ARGUMENTS` to the plan agent.

After completion, update `.app-builder/state.json` to mark Phase 2 as done.
